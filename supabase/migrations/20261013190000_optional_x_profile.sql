-- LinkedIn remains required; X is optional and validated when supplied.
-- Applied and recorded in Supabase migration history on 2026-10-13.
-- NOT VALID preserves legacy rows created before LinkedIn was a separate field.
begin;
alter table public.applications
  drop constraint applications_links_required,
  add constraint applications_links_required check (linkedin is not null) not valid;
commit;
