# CLAUDE.md — bay^2 (baysquared)

This folder is the home for all work on the bay^2 project (Shenzhen robotics trip landing page). Make every change here.

- Brand: **bay^2**, written literally as `bay^2`, lowercase, with a caret and no superscript. Use `baysquared` for folders, repos, file names and URLs. Formerly SOMMER.
- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Original style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand, plus `3d-ochre`, `3d-clay`, `3d-night`. See README.md.
- Live direction is `3d-night` (responsive, full-viewport, separate phone layout) using font option 3: Instrument Serif lowercase wordmark and italic tagline, all lowercase. `apply/` matches it. The others are the original fixed 1280×800 scaled stages.
- `apply/` is a mockup application form (client-side validation only, nothing is sent anywhere yet). Fields follow the applicant questions in the planning doc; the rest of those questions are asked on the interview call.
- Images are shared in `images/` as `baysquared_pic*.jpg`; pages reference them as `../images/<file>`. More source photos are in the user's Downloads folder, still named `sommer_pic1..23.jpg`.
- `3d-night` is a scrolling page: full-screen hero, then sections (trip, how it works with countdown, itinerary, price, FAQ). Keep it to key facts only. Nav links jump to `#trip`, `#how`, `#price`, `#faq`; `Apply` goes to `../apply/`. Countdown targets 9 Nov 2026, 9am PT (17:00 UTC).
- Trip: 11–17 January 2027. Content source is the Google Doc "Make it out of the hood".
- Deploy target: Vercel project `baysquared`, auto-deployed from GitHub `joeljussila/baysquared` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.
