# CLAUDE.md — Sommer

This folder is the home for all work on the Sommer project (Shenzhen robotics trip landing page). Make every change here.

- Plain static HTML, no framework, no build. Keep it that way unless asked.
- Four style directions: `1a` Space, `2f` Sepia, `2h` Threshold, `3d` Glass hand. See README.md.
- Images are shared in `images/`; pages reference them as `../images/<file>`. More source photos (`sommer_pic1..23.jpg`) are in the user's Downloads folder.
- Nav links (`The trip`, `FAQ`, `Apply`) are placeholders (`href="#"`).
- Deploy target: Vercel, from the GitHub repo. When one direction is chosen for production, copy it to the root `index.html` and change its image paths from `../images/` to `images/` (or keep the picker and add a Vercel rewrite).
