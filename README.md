# SOMMER

Landing page for **SOMMER — "Live the future in Shenzhen"**, a by-application robotics trip to Shenzhen, December 2026.

Designs came from Claude Design (`Sommer_ Shenzhen robotics trip landing page.zip`, Downloads, 2026-10-10).

## Style directions

| Folder | Name | Look | Hero image |
|---|---|---|---|
| `1a/` | Space | Near-black, starfield, centered Michroma wordmark, blue dot accent | `sommer_pic16.jpg` |
| `2f/` | Sepia | Full-bleed sepia photo, Cormorant Garamond serif, red dot, "Request to apply" | `sommer_pic5.jpg` |
| `2h/` | Threshold | Dark warm brown, Instrument Serif left-aligned, photo fades in from right | `sommer_pic6.jpg` |
| `3d/` | Glass hand | Light sand background, heavy wide Archivo, cobalt accent | `sommer_pic3.jpg` |
| `3d-ochre/` | Glass hand · Ochre | Burnt ochre background, dark text, cobalt accent | `sommer_pic3.jpg` |
| `3d-clay/` | Glass hand · Clay | Terracotta background, cream text | `sommer_pic3.jpg` |
| `3d-night/` | Glass hand · Night | Deep navy, photo shown as a glowing negative, orange accent | `sommer_pic3.jpg` |

The 3d variants use an SVG `#whiten` filter that maps the photo's baked-in sand to white, then `mix-blend-mode` (multiply, or invert + screen for Night) so the hand sits directly on the new background.

`index.html` at the root is a picker linking to all four.

## Structure

- Each direction is a self-contained static page (`<dir>/index.html`), no build step.
- Shared images live in `images/` and are referenced as `../images/...`.
- Pages render a fixed 1280×800 stage scaled to fit the viewport.

## Run locally

Open `index.html` in a browser, or serve the folder (`npx serve .`).

## Deploy

Static site — deploy to Vercel with no framework preset. To ship a single direction, make that direction the root page (see CLAUDE.md).
