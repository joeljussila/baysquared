-- Run after installing the migration, inside a transaction. No email is sent:
-- pg_net requests only start after COMMIT, and this fixture always rolls back.
begin;
do $$
declare test_id uuid;
begin
  insert into public.applications(name,email,company,based,linkedin,x,role,area,building,why,dates)
  values ('QA notification rollback','qa-notifications@example.com','QA TEST - rolled back','Test city',
    'https://www.linkedin.com/in/qa-notifications',null,'Other','Other',
    'Testing the notification queue without sending mail.','Testing transaction safety and permissions.','No')
  returning id into test_id;
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='queued') then
    raise exception 'New application did not enqueue';
  end if;
  if has_table_privilege('anon','application_notifications.outbox','SELECT') or
     has_function_privilege('anon','application_notifications.dispatch()','EXECUTE') or
     has_function_privilege('authenticated','application_notifications.dispatch()','EXECUTE') then
    raise exception 'Public roles can access the notification queue or dispatcher';
  end if;
  -- Record a synthetic successful provider response to check reconciliation.
  update application_notifications.outbox set status='sending', attempts=1,
    request_id=-721940125, requested_at=now() where application_id=test_id;
  insert into net._http_response(id,status_code,timed_out) values(-721940125,200,false);
  perform application_notifications.dispatch();
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='sent' and sent_at is not null) then
    raise exception 'Successful send was not reconciled';
  end if;
  update net._http_response set status_code=503 where id=-721940125;
  update application_notifications.outbox set status='sending', attempts=1 where application_id=test_id;
  perform application_notifications.dispatch();
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='queued' and next_attempt_at > now()) then
    raise exception 'Failed delivery did not receive a delayed retry';
  end if;
  update application_notifications.outbox set status='sending', attempts=10 where application_id=test_id;
  perform application_notifications.dispatch();
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='failed') then
    raise exception 'Retry limit was not respected';
  end if;
  update application_notifications.outbox set status='sending', attempts=1, request_id=-721940126,
    requested_at=now()-interval '4 minutes' where application_id=test_id;
  perform application_notifications.dispatch();
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='queued') then
    raise exception 'Lost delivery response did not receive a retry';
  end if;
  update application_notifications.outbox set created_at=now()-interval '24 hours' where application_id=test_id;
  perform application_notifications.dispatch();
  if not exists(select 1 from application_notifications.outbox where application_id=test_id and status='failed') then
    raise exception 'Expired idempotency window was not respected';
  end if;
end;
$$;
select 'PASS: queue, private access, success, retries, retry limit, missing response, idempotency expiry' as result;
rollback;
