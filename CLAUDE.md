# CLAUDE.md — Sommer

This folder is the home for all work on the Sommer project (Shenzhen robotics trip landing page). Make every change here.

- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Four style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand. See README.md.
- Images are shared in `images/`; pages reference them as `../images/<file>`. More source photos (`sommer_pic1..23.jpg`) are in the user's Downloads folder.
- Nav links (`The trip`, `FAQ`, `Apply`) are placeholders (`href="#"`).
- Deploy target: Vercel project `sommer`, auto-deployed from GitHub `joeljussila/sommer` main. `/` is rewritten to the live direction in `vercel.json` (currently `3d-night`); the picker is at `/styles/`.
