# CLAUDE.md — bay² (baysquared)

This folder is the home for all work on the bay² project (Shenzhen robotics trip landing page). Make every change here.

- Brand: **bay²**, always lowercase with a superscript 2 (wordmarks use a `<span>` sized .42em, plain text uses the `²` character). Use `baysquared` for folders, repos, file names and URLs. Formerly SOMMER.
- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Original style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand, plus `3d-ochre`, `3d-clay`, `3d-night`. See README.md.
- Live direction is `3d-night` (responsive, full-viewport, separate phone layout). The others are the original fixed 1280×800 scaled stages.
- `apply/` is a mockup application form (all fields required, client-side validation only, nothing is sent anywhere yet).
- Images are shared in `images/` as `baysquared_pic*.jpg`; pages reference them as `../images/<file>`. More source photos are in the user's Downloads folder, still named `sommer_pic1..23.jpg`.
- Nav links `The trip` and `FAQ` are placeholders (`href="#"`); `Apply` on `3d-night` goes to `../apply/`.
- Deploy target: Vercel project `baysquared`, auto-deployed from GitHub `joeljussila/baysquared` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.
