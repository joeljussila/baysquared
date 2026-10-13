-- Applied to Supabase project deltaandbay (kmbhcqnkbiddppzbubxp) on 2026-10-12.
-- Split the single profile link into LinkedIn (required), X (required) and website (optional).
alter table public.applications
  add column linkedin text,
  add column x text,
  add column website text;

-- The old combined field is no longer sent by the form.
alter table public.applications alter column profile drop not null;

-- New applications must include LinkedIn and X in canonical form; website is optional.
-- NOT VALID: existing rows (sent with the old single field) are left as they are.
alter table public.applications
  add constraint applications_linkedin_format check (linkedin ~ '^https://www\.linkedin\.com/in/[A-Za-z0-9_%.-]{3,100}$') not valid,
  add constraint applications_x_format check (x ~ '^https://x\.com/[A-Za-z0-9_]{1,15}$') not valid,
  add constraint applications_website_format check (website is null or (char_length(website) <= 300 and website ~* '^https?://[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}(:[0-9]{1,5})?(/[^[:space:]]*)?$')) not valid,
  add constraint applications_links_required check (linkedin is not null and x is not null) not valid;

grant insert (linkedin, x, website) on public.applications to anon, authenticated;
