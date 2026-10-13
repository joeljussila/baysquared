# CLAUDE.md — delta and bay (deltaandbay)

This folder is the home for all work on the delta and bay project (Shenzhen robotics trip landing page). Make every change here.

- Brand: **delta and bay**, lowercase, words spaced. Use `deltaandbay` for folders, repos, file names and URLs. Formerly bay^2 (baysquared), before that SOMMER.
- Current tagline: **Bridging the Frontiers**. Navigation, section headings and buttons use sentence case; the brand wordmark remains lowercase.
- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Original style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand, plus `3d-ochre`, `3d-clay`, `3d-night`. See README.md.
- Live direction is `3d-night`: Shawn's brand colours (Prussian blue `#050A30`, ivory `#ECE8E0`, glow blue `#0035B1` as a corner edge glow), his vector monogram top-left (`images/deltaandbay_monogram_ivory.svg`, from his brand kit, no frame), Instrument Serif lowercase wordmark. `apply/` matches it.
- `apply/` saves to Supabase project `deltaandbay` (ref `kmbhcqnkbiddppzbubxp`, us-west-1), table `public.applications`, via the REST API with the publishable key. RLS: public can insert only (no read/update/delete); read applications in the Supabase dashboard. Schema in `supabase/migrations/`. If you add or rename a form field, update the table, the column grant and the `FIELDS` list in the page script together. Fields follow the applicant questions in the planning doc; the rest of those questions are asked on the interview call.
- Images are shared in `images/` as `deltaandbay_pic*.jpg`; pages reference them as `../images/<file>`. More source photos are in the user's Downloads folder, still named `sommer_pic1..23.jpg`.
- `3d-night` is a scrolling page: full-screen hero, then sections (trip, how it works with countdown, itinerary, price, FAQ). Keep it to key facts only. Nav links jump to `#trip`, `#how`, `#price`, `#faq`; `Apply` goes to `../apply/`. Countdown targets 9 Nov 2026, 9am PT (17:00 UTC).
- Trip: 11–17 January 2027. Content source is the Google Doc "Make it out of the hood".
- Deploy target: Vercel project `deltaandbay` (domain deltaandbay.com), auto-deployed from GitHub `joeljussila/deltaandbay` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.

- Brand background artwork: `images/deltaandbay_edge_glow.svg` uses the original gradient definitions from `syqgenesis/sz-trips`, branch `claude/focused-euler-hw4jrr`, commit `fd42b97da18129ab06f6ddd72d38277696799ebe`, `brand/backgrounds/edge-glow-16x9.svg`. Preserve its blue hue when compositing hero media; do not replace it with approximate purple/navy gradients.

- The decorative edge-glow SVG uses `preserveAspectRatio="none"` so its gradients fill portrait backgrounds without transparent letterbox bands. Do not remove this attribute.
