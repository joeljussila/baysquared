# CLAUDE.md — delta and bay (deltaandbay)

Read `docs/CHAT_HANDOFF.md` first for current shared context, production decisions and pending requests. Inspect Git status and uncommitted changes before editing; multiple chats may be working simultaneously.

This folder is the home for all work on the delta and bay project (Shenzhen robotics trip landing page). Make every change here.

- Brand: **Delta & Bay**, capitalised, with an ampersand (Shawn's request, 14 Oct 2026; this replaces the earlier lowercase wordmark). Use `deltaandbay` for folders, repos, file names and URLs. Formerly delta and bay, bay^2 (baysquared), before that SOMMER.
- Current tagline: **Bridging the Frontiers**. Navigation, section headings and buttons use sentence case; the brand is written Delta & Bay.
- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Original style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand, plus `3d-ochre`, `3d-clay`, `3d-night`. See README.md.
- Live direction is `3d-night`: Shawn's brand colours (Prussian blue `#050A30`, ivory `#ECE8E0`), his vector monogram top-left (`images/deltaandbay_monogram_ivory.svg`, from his brand kit, no frame), Instrument Serif wordmark "Delta & Bay". `apply/` matches it.
- `apply/` saves to Supabase project `deltaandbay` (ref `kmbhcqnkbiddppzbubxp`, us-west-1), table `public.applications`, via the REST API with the publishable key. RLS: public can insert only (no read/update/delete); read applications in the Supabase dashboard. Schema in `supabase/migrations/`. If you add or rename a form field, update the table, the column grant and the `FIELDS` list in the page script together. Fields follow the applicant questions in the planning doc; the rest of those questions are asked on the interview call.
- Images are shared in `images/` as `deltaandbay_pic*.jpg`; pages reference them as `../images/<file>`. More source photos are in the user's Downloads folder, still named `sommer_pic1..23.jpg`.
- `3d-night` is a scrolling page: full-screen hero, then sections (trip with "You leave with", how it works with countdown, the week, price, FAQ). Keep it to key facts only. Nav links jump to `#trip`, `#price`, `#faq`; `Apply` goes to `../apply/`. Price sits before the FAQ, shows the four-tier ladder and the 10-bookings-by-30-November refund rule, and says "including tax". The countdown targets the first-round application deadline, Sunday 1 Nov 2026, 11:59pm PT (07:59 UTC on 2 Nov); booking still opens 9 Nov, 9am PT.
- The week is described by theme with no company names or host logos (names and logos are shared on the interview call, never on the site). `images/hosts/` is kept but not used on the page.
- Trip: 11–17 January 2027. Content source is the Google Doc "Make it out of the hood".
- Deploy target: Vercel project `deltaandbay` (domain deltaandbay.com), auto-deployed from GitHub `joeljussila/deltaandbay` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.



- Live pages use solid Prussian blue (#050A30), without decorative background gradients or video blend overlays. The video and its poster are color-graded blue directly in their files.
