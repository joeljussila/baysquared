# CLAUDE.md — bay² (baysquared)

This folder is the home for all work on the bay² project (Shenzhen robotics trip landing page). Make every change here.

- Brand: **bay²**, always lowercase with a superscript 2 (wordmarks use a `<span>` sized .42em, plain text uses the `²` character). Use `baysquared` for folders, repos, file names and URLs. Formerly SOMMER; the original Downloads photos are still named `sommer_pic*.jpg`.

- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Four style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand. See README.md.
- Images are shared in `images/` as `baysquared_pic*.jpg`; pages reference them as `../images/<file>`. More source photos (`baysquared_pic1..23.jpg`) are in the user's Downloads folder.
- Nav links (`The trip`, `FAQ`, `Apply`) are placeholders (`href="#"`).
- Deploy target: Vercel project `baysquared`, auto-deployed from GitHub `joeljussila/baysquared` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.
