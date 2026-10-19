# browser-start-page

A single-file browser start page. No build step, no external dependencies — everything runs in the browser with plain localStorage.

## Files

| Path | Purpose |
|------|---------|
| `~/.local/share/browser-start-page/index.html` | The page itself |
| `~/.config/cconf/environments/browser-start-page/start-page-server.py` | Local HTTP server (feed proxy + static files) |
| `~/.config/cconf/environments/browser-start-page/browser-start-page.service` | systemd user service |

## Setup

### Serve via the local server (recommended)

The server lets feeds load without CORS issues and keeps everything on localhost.

```bash
# install and start the systemd user service
cp ~/.config/cconf/environments/browser-start-page/browser-start-page.service \
   ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now browser-start-page
```

The page is then at `http://localhost:8420`. Point your browser's new-tab or home page there.

### Open as a local file

Open `index.html` directly as a `file://` URL. Feeds are fetched via public CORS proxies as fallback (`api.allorigins.win`, `corsproxy.io`).

## Features

**Shortcuts** — bookmark tiles with favicons, drag to reorder, inline add/edit.

**Feeds** — RSS, Atom, podcasts, and YouTube playlists/channels in a responsive grid.

- Podcast feeds auto-detect and show episode artwork + ▶ links.
- YouTube feeds show thumbnails alongside titles.
- YouTube channel and playlist URLs are auto-converted to their RSS equivalents on input.

**Weather** — current conditions via [Open-Meteo](https://open-meteo.com/) (no API key). Supports auto location or manual city search.

**Wallpaper** — none, solid colour, remote image URL, or uploaded file.

**Theme** — Catppuccin Latte (light) / Mocha (dark), following the OS preference by default.

## Adding feeds

Open Settings → Feeds → `+ Add feed`. Accepted inputs:

- Any RSS or Atom URL
- Podcast RSS URL
- `https://www.youtube.com/channel/UC…` → converted to `feeds/videos.xml?channel_id=…`
- `https://www.youtube.com/playlist?list=PL…` → converted to `feeds/videos.xml?playlist_id=…`
- Direct YouTube RSS URL (`https://www.youtube.com/feeds/videos.xml?…`)

> `@handle` style YouTube URLs require a YouTube Data API key to resolve and are not auto-converted. Use the channel URL or RSS URL form instead.

## Data

Everything is stored in `localStorage` under the key `startpage.settings.v1`. Use **Export config** in Settings to download a portable JSON backup, and **Import config** to restore it.

## Network calls

| Endpoint | Purpose |
|----------|---------|
| `api.open-meteo.com` | Weather (no key required) |
| `geocoding-api.open-meteo.com` | City name → coordinates |
| `api.bigdatacloud.net` | Coordinates → city name |
| `www.google.com/s2/favicons` | Shortcut favicons (by domain only) |
| `/feed?url=…` (local) | Feed proxy when served via the local server |
| `api.allorigins.win`, `corsproxy.io` | Feed CORS fallback when opened as `file://` |
