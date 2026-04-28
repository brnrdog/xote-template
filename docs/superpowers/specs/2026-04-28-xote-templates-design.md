# Xote base templates — design

## Goal

Provide two copy-pasteable starter templates for xote applications: one
client-only (CSR), one server-rendered with hydration (SSR). Both are minimal
clean slates with a `Counter` component, a Tailwind-powered CSS file, and a
`Main.res` (or equivalent) entry point.

## Repo layout

```
templates/
  csr/
  ssr/
README.md                       # explains the two templates
docs/superpowers/specs/...      # this design doc
```

No shared root `package.json` — each template is fully standalone.

## Shared tech stack

- ReScript ^12.0.0 (`"jsx": {"version": 4, "module": "XoteJSX"}`)
- xote ^6.2.0
- Vite ^7
- Tailwind CSS v4 via `@tailwindcss/vite` plugin (CSS-first config)
- A single CSS entry `src/styles.css` containing `@import "tailwindcss";`

## Component model (shared shape)

Every template ships:

- `src/styles.css` — `@import "tailwindcss";`
- `src/Counter.res` — `@jsx.component`, signal-backed counter rendered with
  Tailwind utility classes
- An entry that imports `styles.css` and mounts/hydrates the counter

## CSR template (`templates/csr/`)

```
csr/
  index.html
  vite.config.mjs
  rescript.json
  package.json
  src/
    styles.css
    Counter.res
    Main.res
```

- `index.html` declares `<div id="app"></div>` and `<script type="module"
  src="/src/Main.res.mjs"></script>`.
- `Main.res` imports the stylesheet and calls `View.mountById(<Counter />,
  "app")`.
- `Counter.res` uses `Signal.make(0)`.
- Vite config registers `@tailwindcss/vite`. No SSR plugins.
- Scripts: `dev`, `build`, `preview`, `res:dev`, `res:build`, `res:clean`.
- Workflow: run `npm run res:dev` and `npm run dev` in parallel.

## SSR template (`templates/ssr/`)

```
ssr/
  index.html              # contains <!--app-html--> and <!--app-state--> placeholders
  vite.config.mjs
  server.mjs              # Node HTTP server with Vite middleware
  rescript.json
  package.json
  src/
    styles.css
    Counter.res           # uses SSRState.signal
    App.res               # shared component-factory used by server + client
    Client.res            # Hydration.hydrateById(...)
    Server.res            # exports render() returning SSR HTML
```

- `App.res` exposes `makeState()` and `view(state)` so server and client share
  the same component graph.
- `Counter.res` uses `SSRState.signal("count", 0, SSRState.Codec.int)` so the
  count survives hydration.
- `Server.res` calls `SSR.renderDocument` (or returns just the body fragment;
  see implementation note below) and produces a string.
- `server.mjs`:
  - Dev: creates Vite in `middlewareMode`, transforms `index.html`, calls
    `Server.render()`, injects body + state script.
  - Prod: serves the built client assets and runs the prebuilt
    `Server.res.mjs` to render on each request.
- `Client.res` calls `Hydration.hydrateById(view, "root")`.
- Scripts: `dev` (`node server.mjs`), `build` (runs `build:client` then
  `build:ssr`), `build:client` (`vite build`), `build:ssr`
  (`vite build --ssr src/Server.res.mjs --outDir dist/server`), `start`
  (`NODE_ENV=production node server.mjs`), plus the standard `res:*` scripts.

### Implementation note (SSR rendering shape)

The `index.html` strategy (placeholder injection) mirrors the standard Vite
SSR pattern. `Server.render()` returns `{html, stateScript}`; `server.mjs`
substitutes both into the HTML template. This keeps Tailwind/Vite asset
handling working in dev (Vite transforms `index.html`) without xote's
`SSR.renderDocument` taking ownership of the whole document.

## Top-level README

Short README at repo root explaining:

- What xote is (one line + link)
- The two templates and when to pick each
- Quickstart for each (cd, install, dev)
- How to copy one out (`degit` or `cp -r`)

## Out of scope

- Routing examples (xote has `Router`, but the templates stay minimal)
- Testing setup
- Deployment guides
- A monorepo / shared `package.json`
- TypeScript or any non-ReScript variant
