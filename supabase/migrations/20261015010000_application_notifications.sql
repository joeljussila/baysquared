-- Applied to Supabase and recorded in migration history on 2026-10-14.
-- Requires a sending-only Resend key for deltaandbay.com in Vault, named
-- deltaandbay_resend_api_key. Never put its value in this file or frontend code.
-- This migration does not notify for old applications.
begin;
create extension if not exists pg_net with schema extensions;
create extension if not exists pg_cron;
create schema application_notifications;
revoke all on schema application_notifications from public, anon, authenticated;

create table application_notifications.outbox (
  application_id uuid primary key references public.applications(id) on delete cascade,
  created_at timestamptz not null default now(),
  status text not null default 'queued' check (status in ('queued','sending','sent','failed')),
  attempts integer not null default 0,
  request_id bigint,
  requested_at timestamptz,
  next_attempt_at timestamptz not null default now(),
  sent_at timestamptz,
  last_http_status integer,
  last_error text
);
alter table application_notifications.outbox enable row level security;
revoke all on application_notifications.outbox from public, anon, authenticated;

create function application_notifications.enqueue()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into application_notifications.outbox(application_id) values (new.id);
  return new;
end;
$$;
revoke all on function application_notifications.enqueue() from public, anon, authenticated;

create trigger application_notification_enqueue after insert on public.applications
for each row execute function application_notifications.enqueue();

create function application_notifications.dispatch()
returns void language plpgsql security definer set search_path = '' as $$
declare
  delivery record;
  response record;
  sending_key text;
  queued_request bigint;
begin
  -- Prevent overlapping cron/manual dispatches.
  if not pg_catalog.pg_try_advisory_xact_lock(721940125) then return; end if;

  for delivery in select * from application_notifications.outbox where status = 'sending'
  loop
    select status_code, timed_out, error_msg into response
    from net._http_response where id = delivery.request_id;
    if found and response.status_code between 200 and 299 then
      update application_notifications.outbox set status = 'sent', sent_at = now(),
        last_http_status = response.status_code, last_error = null
      where application_id = delivery.application_id;
    elsif found or delivery.requested_at < now() - interval '3 minutes' then
      update application_notifications.outbox set
        status = case when attempts >= 10 then 'failed' else 'queued' end,
        last_http_status = response.status_code,
        last_error = case when response.status_code is not null
          then 'Resend HTTP ' || response.status_code::text else 'Delivery request timed out' end,
        next_attempt_at = now() + pg_catalog.make_interval(secs => least(3600, (60 * power(2, attempts - 1))::integer))
      where application_id = delivery.application_id;
    end if;
  end loop;

  -- Resend deduplicates identical idempotency keys for 24 hours. Stop automatic
  -- retries before that window expires, so an uncertain outcome cannot duplicate mail.
  update application_notifications.outbox set status = 'failed', last_error = 'Retry window expired; review in Resend before retrying'
  where status = 'queued' and created_at < now() - interval '23 hours';

  select decrypted_secret into sending_key from vault.decrypted_secrets
  where name = 'deltaandbay_resend_api_key';
  if sending_key is null or sending_key = '' then return; end if;

  for delivery in select * from application_notifications.outbox
    where status = 'queued' and next_attempt_at <= now() order by created_at limit 10
    for update skip locked
  loop
    begin
      select net.http_post(
        url := 'https://api.resend.com/emails',
        headers := jsonb_build_object('Authorization', 'Bearer ' || sending_key,
          'Content-Type', 'application/json', 'Idempotency-Key', 'application/' || delivery.application_id::text),
        body := jsonb_build_object(
          'from', 'delta & bay <applications@deltaandbay.com>',
          'to', jsonb_build_array('info@deltaandbay.com'),
          'subject', 'New delta & bay application',
          'text', 'A new application has been saved.' || E'\n\nApplication ID: ' || delivery.application_id::text ||
            E'\n\nReview it in Supabase (sign-in required):\nhttps://supabase.com/dashboard/project/kmbhcqnkbiddppzbubxp/editor\n\nApplicant answers stay in Supabase.'),
        timeout_milliseconds := 10000
      ) into queued_request;
      update application_notifications.outbox set status = 'sending',
        attempts = attempts + 1, request_id = queued_request, requested_at = now()
      where application_id = delivery.application_id;
    exception when others then
      update application_notifications.outbox set attempts = attempts + 1,
        status = case when attempts + 1 >= 10 then 'failed' else 'queued' end,
        next_attempt_at = now() + interval '5 minutes', last_error = 'Could not queue delivery; inspect database logs'
      where application_id = delivery.application_id;
    end;
  end loop;
end;
$$;
revoke all on function application_notifications.dispatch() from public, anon, authenticated;
select cron.schedule('deltaandbay-application-notifications', '* * * * *',
  'select application_notifications.dispatch();');
commit;
