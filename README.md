# delta and bay (deltaandbay)

Landing page for **delta and bay — "Live the future in Shenzhen"**, a by-application robotics and hardware delegation to Shenzhen, 11–17 January 2027.

Brand is written **delta and bay** (lowercase). Use `deltaandbay` for folders, repos, file names and URLs. Earlier names: bay^2 (baysquared), SOMMER. Live at https://deltaandbay.com.

Designs came from Claude Design (`Sommer_ Shenzhen robotics trip landing page.zip`, Downloads, 2026-10-10).

## Style directions

| Folder | Name | Look | Hero image |
|---|---|---|---|
| `1a/` | Space | Near-black, starfield, centered Michroma wordmark, blue dot accent | `deltaandbay_pic16.jpg` |
| `2f/` | Sepia | Full-bleed sepia photo, Cormorant Garamond serif, red dot, "Request to apply" | `deltaandbay_pic5.jpg` |
| `2h/` | Threshold | Dark warm brown, Instrument Serif left-aligned, photo fades in from right | `deltaandbay_pic6.jpg` |
| `3d/` | Glass hand | Light sand background, heavy wide Archivo, cobalt accent | `deltaandbay_pic3.jpg` |
| `3d-ochre/` | Glass hand · Ochre | Burnt ochre background, dark text, cobalt accent | `deltaandbay_pic3.jpg` |
| `3d-clay/` | Glass hand · Clay | Terracotta background, cream text | `deltaandbay_pic3.jpg` |
| `3d-night/` | Glass hand · Night | Deep navy, photo shown as a glowing negative, orange accent | `deltaandbay_pic3.jpg` |

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

## Font options

`fonts/` holds five typography variants of `3d-night` (picker at `/fonts/`): 1 wide caps (Archivo), 2 tech caps (Michroma), 3 serif lowercase (Instrument Serif), 4 grotesk lowercase (Space Grotesk), 5 mono lowercase (IBM Plex Mono). Once one is chosen, fold its CSS into `3d-night`.

## Brand directions

`brand/` holds three full-page brand directions built on the live page (picker and logo board at `/brand/`): A Deco Machine (a16z-inspired, Big Shoulders Display, brass on ink, sunburst), B Signal (FR8-inspired, Chakra Petch, black/white/signal orange), C Bridge (SILTA-inspired, Syncopate, midnight navy). Each adds a square logo top-left and slow rays + waves behind the hand. Fold the chosen one into `3d-night` and `apply/`.
