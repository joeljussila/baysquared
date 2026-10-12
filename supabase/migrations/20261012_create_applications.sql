-- Applied to Supabase project deltaandbay (kmbhcqnkbiddppzbubxp) on 2026-10-12.
create table public.applications (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null check (char_length(btrim(name)) between 1 and 200),
  email text not null check (char_length(email) <= 320 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  company text not null check (char_length(btrim(company)) between 1 and 200),
  based text not null check (char_length(btrim(based)) between 1 and 200),
  profile text not null check (char_length(btrim(profile)) between 1 and 500),
  role text not null check (role in ('Founder','Investor','Engineer or researcher','Product, operations or sourcing lead','Other')),
  area text not null check (area in ('Robotics and automation','Physical AI and data','Consumer hardware and wearables','Energy and climate hardware','Medtech, BCI and neurotech','Semiconductors and sensors','Other')),
  building text not null check (char_length(btrim(building)) between 10 and 4000),
  why text not null check (char_length(btrim(why)) between 10 and 4000),
  dates text not null check (dates in ('Yes','No')),
  heard text check (heard is null or char_length(heard) <= 500),
  status text not null default 'new' check (status in ('new','call booked','accepted','declined'))
);

comment on table public.applications is 'delta and bay trip applications from deltaandbay.com/apply. Public can insert only; read via dashboard / service role.';

alter table public.applications enable row level security;

-- Public site may submit applications, but cannot read, update or delete them.
create policy "Anyone can submit an application"
  on public.applications for insert
  to anon, authenticated
  with check (status = 'new');

revoke all on public.applications from anon, authenticated;
grant insert (name, email, company, based, profile, role, area, building, why, dates, heard) on public.applications to anon, authenticated;

create index applications_created_at_idx on public.applications (created_at desc);
