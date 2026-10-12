-- Applied to Supabase project deltaandbay (kmbhcqnkbiddppzbubxp) on 2026-10-12.
-- New applications must give a LinkedIn profile or X profile link, in the canonical form the form sends.
-- NOT VALID: existing rows are left as they are; the rule applies to new inserts.
alter table public.applications
  add constraint applications_profile_linkedin_or_x
  check (profile ~ '^https://www\.linkedin\.com/in/[A-Za-z0-9_%.-]{3,100}$' or profile ~ '^https://x\.com/[A-Za-z0-9_]{1,15}$')
  not valid;
