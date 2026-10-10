# bay^2 (baysquared)

Landing page for **bay^2 — "Live the future in Shenzhen"**, a by-application robotics trip to Shenzhen, December 2026.

Brand is written **bay^2** (lowercase, literal caret, no superscript) on the site. Use `baysquared` for folders, repos, file names and URLs. The project was originally called SOMMER.

Designs came from Claude Design (`Sommer_ Shenzhen robotics trip landing page.zip`, Downloads, 2026-10-10).

## Style directions

| Folder | Name | Look | Hero image |
|---|---|---|---|
| `1a/` | Space | Near-black, starfield, centered Michroma wordmark, blue dot accent | `baysquared_pic16.jpg` |
| `2f/` | Sepia | Full-bleed sepia photo, Cormorant Garamond serif, red dot, "Request to apply" | `baysquared_pic5.jpg` |
| `2h/` | Threshold | Dark warm brown, Instrument Serif left-aligned, photo fades in from right | `baysquared_pic6.jpg` |
| `3d/` | Glass hand | Light sand background, heavy wide Archivo, cobalt accent | `baysquared_pic3.jpg` |
| `3d-ochre/` | Glass hand · Ochre | Burnt ochre background, dark text, cobalt accent | `baysquared_pic3.jpg` |
| `3d-clay/` | Glass hand · Clay | Terracotta background, cream text | `baysquared_pic3.jpg` |
| `3d-night/` | Glass hand · Night | Deep navy, photo shown as a glowing negative, orange accent | `baysquared_pic3.jpg` |

The 3d variants use an SVG `#whiten` filter that maps the photo's baked-in sand to white, then `mix-blend-mode` (multiply, or invert + screen for Night) so the hand sits directly on the new background.

`styles/index.html` is a picker linking to every direction. On Vercel, `/` serves `3d-night` (rewrite in `vercel.json`).

## Structure

- Each direction is a self-contained static page (`<dir>/index.html`), no build step.
- Shared images live in `images/` and are referenced as `../images/...`.
- Pages render a fixed 1280×800 stage scaled to fit the viewport.

## Run locally

Open `styles/index.html` (picker) in a browser, or serve the folder (`npx serve .`).

## Deploy

Static site — deploy to Vercel with no framework preset. To ship a single direction, make that direction the root page (see CLAUDE.md).
