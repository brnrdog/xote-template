# Xote Base Templates Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship two minimal, copy-pasteable xote starter templates (one client-only, one SSR with hydration) that share the same tech stack and the same `Counter` example.

**Architecture:** Two standalone, side-by-side templates under `templates/csr/` and `templates/ssr/`. Each is a self-contained npm project (its own `package.json`, `rescript.json`, `vite.config.mjs`). The CSR template mounts a single component with `View.mountById`. The SSR template uses a thin Node HTTP server that runs Vite in middleware mode for dev, calls a `Server.render()` ReScript function, and injects the rendered HTML + `SSRState` script into the Vite-transformed `index.html`. A shared `App.res` factory keeps server and client rendering identical.

**Tech Stack:** ReScript ^12, xote ^6.2 (npm `xote`), Vite ^7, Tailwind CSS v4 via `@tailwindcss/vite`.

**Verification approach:** These templates are not unit-tested. Each task that produces a runnable template ends with concrete `npm` commands and expected outputs (build success, dev server reachable, page contents).

---

## File Structure

```
templates/
  csr/
    .gitignore
    index.html
    package.json
    rescript.json
    vite.config.mjs
    src/
      Counter.res
      Main.res
      styles.css
  ssr/
    .gitignore
    index.html
    package.json
    rescript.json
    server.mjs
    vite.config.mjs
    src/
      App.res
      Client.res
      Counter.res
      Server.res
      styles.css
README.md
```

---

## Task 1: Top-level README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write the README**

```markdown
# xote templates

Base templates for [xote](https://github.com/brnrdog/xote) applications.

Two flavors are available:

| Template | Path | Use when |
| --- | --- | --- |
| **CSR** (client-only) | [`templates/csr`](./templates/csr) | You want a SPA: render in the browser, no Node server. |
| **SSR** (server-rendered) | [`templates/ssr`](./templates/ssr) | You want HTML rendered on the server with full hydration. |

Both share the same stack:

- ReScript v12 with the xote JSX transform
- [xote](https://www.npmjs.com/package/xote) for reactive views and (optionally) SSR
- Vite 7
- Tailwind CSS v4 (via `@tailwindcss/vite`, CSS-first config)

## Quickstart

Pick a template, copy it out, install, and run.

```bash
# CSR
cp -r templates/csr my-app && cd my-app
npm install
npm run res:dev   # in one terminal
npm run dev       # in another

# SSR
cp -r templates/ssr my-app && cd my-app
npm install
npm run res:dev   # in one terminal
npm run dev       # in another
```

Open the URL Vite prints. Click the counter buttons.
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "Add top-level README"
```

---

## Task 2: CSR template scaffolding (configs)

**Files:**
- Create: `templates/csr/package.json`
- Create: `templates/csr/rescript.json`
- Create: `templates/csr/vite.config.mjs`
- Create: `templates/csr/.gitignore`
- Create: `templates/csr/index.html`

- [ ] **Step 1: Write `templates/csr/package.json`**

```json
{
  "name": "xote-csr-template",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "res:dev": "rescript -w",
    "res:build": "rescript",
    "res:clean": "rescript clean"
  },
  "dependencies": {
    "rescript-signals": "^3.1.0",
    "xote": "^6.2.0"
  },
  "devDependencies": {
    "@tailwindcss/vite": "^4.0.0",
    "rescript": "^12.0.0-beta.1",
    "tailwindcss": "^4.0.0",
    "vite": "^7.0.0"
  }
}
```

- [ ] **Step 2: Write `templates/csr/rescript.json`**

```json
{
  "name": "xote-csr-template",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    }
  ],
  "package-specs": {
    "module": "esmodule",
    "in-source": true
  },
  "suffix": ".res.mjs",
  "dependencies": ["xote", "rescript-signals"],
  "jsx": {
    "version": 4,
    "module": "XoteJSX"
  },
  "compiler-flags": ["-open Xote"]
}
```

- [ ] **Step 3: Write `templates/csr/vite.config.mjs`**

```js
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
```

- [ ] **Step 4: Write `templates/csr/.gitignore`**

```
node_modules
dist
lib
*.res.mjs
*.res.js
.DS_Store
```

- [ ] **Step 5: Write `templates/csr/index.html`**

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>xote · CSR template</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/Main.res.mjs"></script>
  </body>
</html>
```

- [ ] **Step 6: Commit**

```bash
git add templates/csr/package.json templates/csr/rescript.json templates/csr/vite.config.mjs templates/csr/.gitignore templates/csr/index.html
git commit -m "Add CSR template scaffolding"
```

---

## Task 3: CSR template source files

**Files:**
- Create: `templates/csr/src/styles.css`
- Create: `templates/csr/src/Counter.res`
- Create: `templates/csr/src/Main.res`

- [ ] **Step 1: Write `templates/csr/src/styles.css`**

```css
@import "tailwindcss";
```

- [ ] **Step 2: Write `templates/csr/src/Counter.res`**

```rescript
@jsx.component
let make = () => {
  let count = Signal.make(0)

  let decrement = (_: Dom.event) => Signal.update(count, n => n - 1)
  let increment = (_: Dom.event) => Signal.update(count, n => n + 1)

  <div className="flex items-center gap-3 p-6">
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={decrement}>
      {View.text("-")}
    </button>
    <span className="font-mono text-xl tabular-nums">
      {View.signalText(() => Signal.get(count)->Int.toString)}
    </span>
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={increment}>
      {View.text("+")}
    </button>
  </div>
}
```

- [ ] **Step 3: Write `templates/csr/src/Main.res`**

```rescript
%%raw(`import "./styles.css"`)

View.mountById(<Counter />, "app")
```

- [ ] **Step 4: Commit**

```bash
git add templates/csr/src
git commit -m "Add CSR template source: Counter + Main"
```

---

## Task 4: Verify CSR template builds and runs

**Files:**
- None (verification only)

- [ ] **Step 1: Install dependencies**

Run:
```bash
cd templates/csr
npm install
```

Expected: completes without errors. `node_modules/` populated. `xote`, `rescript`, `vite`, `tailwindcss`, `@tailwindcss/vite` all present.

- [ ] **Step 2: Build ReScript**

Run:
```bash
npx rescript
```

Expected: exits 0. `src/Counter.res.mjs` and `src/Main.res.mjs` exist.

- [ ] **Step 3: Build the bundle**

Run:
```bash
npm run build
```

Expected: exits 0. `dist/index.html`, `dist/assets/*.js`, `dist/assets/*.css` exist. The CSS file contains Tailwind utility output (e.g. `.flex`, `.p-6`).

- [ ] **Step 4: Smoke-test the dev server**

Run:
```bash
npm run dev &
sleep 3
curl -sf http://localhost:5173/ | grep -q '<div id="app">'
kill %1
```

Expected: `curl` returns 0 (the `<div id="app">` is in the served HTML).

- [ ] **Step 5: Clean up build artifacts and return to repo root**

Run:
```bash
rm -rf templates/csr/node_modules templates/csr/dist
find templates/csr -name '*.res.mjs' -delete
cd ../..
```

- [ ] **Step 6: Commit (no-op if nothing changed)**

If `git status` shows nothing, skip. Otherwise:

```bash
git add -A templates/csr
git commit -m "Verify CSR template builds and serves"
```

---

## Task 5: SSR template scaffolding (configs)

**Files:**
- Create: `templates/ssr/package.json`
- Create: `templates/ssr/rescript.json`
- Create: `templates/ssr/vite.config.mjs`
- Create: `templates/ssr/.gitignore`
- Create: `templates/ssr/index.html`

- [ ] **Step 1: Write `templates/ssr/package.json`**

```json
{
  "name": "xote-ssr-template",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "node server.mjs",
    "start": "NODE_ENV=production node server.mjs",
    "build": "npm run build:client && npm run build:ssr",
    "build:client": "vite build --outDir dist/client",
    "build:ssr": "vite build --ssr src/Server.res.mjs --outDir dist/server",
    "res:dev": "rescript -w",
    "res:build": "rescript",
    "res:clean": "rescript clean"
  },
  "dependencies": {
    "rescript-signals": "^3.1.0",
    "xote": "^6.2.0"
  },
  "devDependencies": {
    "@tailwindcss/vite": "^4.0.0",
    "rescript": "^12.0.0-beta.1",
    "tailwindcss": "^4.0.0",
    "vite": "^7.0.0"
  }
}
```

- [ ] **Step 2: Write `templates/ssr/rescript.json`**

```json
{
  "name": "xote-ssr-template",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    }
  ],
  "package-specs": {
    "module": "esmodule",
    "in-source": true
  },
  "suffix": ".res.mjs",
  "dependencies": ["xote", "rescript-signals"],
  "jsx": {
    "version": 4,
    "module": "XoteJSX"
  },
  "compiler-flags": ["-open Xote"]
}
```

- [ ] **Step 3: Write `templates/ssr/vite.config.mjs`**

```js
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
  build: {
    rollupOptions: {
      input: "index.html",
    },
  },
});
```

- [ ] **Step 4: Write `templates/ssr/.gitignore`**

```
node_modules
dist
lib
*.res.mjs
*.res.js
.DS_Store
```

- [ ] **Step 5: Write `templates/ssr/index.html`**

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>xote · SSR template</title>
    <link rel="stylesheet" href="/src/styles.css" />
  </head>
  <body>
    <div id="root"><!--app-html--></div>
    <!--app-state-->
    <script type="module" src="/src/Client.res.mjs"></script>
  </body>
</html>
```

- [ ] **Step 6: Commit**

```bash
git add templates/ssr/package.json templates/ssr/rescript.json templates/ssr/vite.config.mjs templates/ssr/.gitignore templates/ssr/index.html
git commit -m "Add SSR template scaffolding"
```

---

## Task 6: SSR template — shared App, Counter, Client

**Files:**
- Create: `templates/ssr/src/styles.css`
- Create: `templates/ssr/src/Counter.res`
- Create: `templates/ssr/src/App.res`
- Create: `templates/ssr/src/Client.res`

- [ ] **Step 1: Write `templates/ssr/src/styles.css`**

```css
@import "tailwindcss";
```

- [ ] **Step 2: Write `templates/ssr/src/Counter.res`**

The counter uses `SSRState.signal` so its value survives hydration.

```rescript
@jsx.component
let make = () => {
  let count = SSRState.signal("count", 0, SSRState.Codec.int)

  let decrement = (_: Dom.event) => Signal.update(count, n => n - 1)
  let increment = (_: Dom.event) => Signal.update(count, n => n + 1)

  <div className="flex items-center gap-3 p-6">
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={decrement}>
      {View.text("-")}
    </button>
    <span className="font-mono text-xl tabular-nums">
      {View.signalText(() => Signal.get(count)->Int.toString)}
    </span>
    <button
      className="px-3 py-1 rounded bg-slate-900 text-white hover:bg-slate-700"
      onClick={increment}>
      {View.text("+")}
    </button>
  </div>
}
```

- [ ] **Step 3: Write `templates/ssr/src/App.res`**

`App.view` returns a thunk so the server and client can each invoke it inside their own owner/effect contexts.

```rescript
let view = () => <Counter />
```

- [ ] **Step 4: Write `templates/ssr/src/Client.res`**

```rescript
%%raw(`import "./styles.css"`)

let _ = Hydration.hydrateById(App.view, "root")
```

- [ ] **Step 5: Commit**

```bash
git add templates/ssr/src/styles.css templates/ssr/src/Counter.res templates/ssr/src/App.res templates/ssr/src/Client.res
git commit -m "Add SSR template: Counter, App, Client"
```

---

## Task 7: SSR template — Server.res and server.mjs

**Files:**
- Create: `templates/ssr/src/Server.res`
- Create: `templates/ssr/server.mjs`

- [ ] **Step 1: Write `templates/ssr/src/Server.res`**

`render` returns the rendered body markup plus the `SSRState` script tag string. The Node server inserts both into the Vite-transformed `index.html`.

```rescript
type rendered = {
  html: string,
  stateScript: string,
}

let render = (): rendered => {
  let html = SSR.renderToString(App.view)
  let stateScript = SSRState.generateScript()
  {html, stateScript}
}
```

- [ ] **Step 2: Write `templates/ssr/server.mjs`**

```js
import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PORT = Number(process.env.PORT ?? 3000);
const isProd = process.env.NODE_ENV === "production";

async function createDevHandler() {
  const { createServer } = await import("vite");
  const vite = await createServer({
    root: __dirname,
    server: { middlewareMode: true },
    appType: "custom",
  });

  return async (req, res) => {
    vite.middlewares(req, res, async () => {
      try {
        const url = req.url ?? "/";
        const templatePath = path.join(__dirname, "index.html");
        let template = fs.readFileSync(templatePath, "utf-8");
        template = await vite.transformIndexHtml(url, template);

        const { render } = await vite.ssrLoadModule("/src/Server.res.mjs");
        const { html, stateScript } = render();

        const page = template
          .replace("<!--app-html-->", html)
          .replace("<!--app-state-->", stateScript);

        res.statusCode = 200;
        res.setHeader("Content-Type", "text/html");
        res.end(page);
      } catch (err) {
        vite.ssrFixStacktrace(err);
        res.statusCode = 500;
        res.end(String(err?.stack ?? err));
      }
    });
  };
}

async function createProdHandler() {
  const clientDir = path.join(__dirname, "dist/client");
  const templatePath = path.join(clientDir, "index.html");
  const template = fs.readFileSync(templatePath, "utf-8");
  const { render } = await import(
    path.join(__dirname, "dist/server/Server.res.mjs")
  );

  const mime = {
    ".js": "text/javascript",
    ".mjs": "text/javascript",
    ".css": "text/css",
    ".svg": "image/svg+xml",
    ".ico": "image/x-icon",
    ".png": "image/png",
    ".jpg": "image/jpeg",
    ".woff2": "font/woff2",
  };

  const serveStatic = (filePath, res) => {
    const ext = path.extname(filePath);
    res.statusCode = 200;
    res.setHeader("Content-Type", mime[ext] ?? "application/octet-stream");
    fs.createReadStream(filePath).pipe(res);
  };

  return (req, res) => {
    const url = (req.url ?? "/").split("?")[0];
    if (url !== "/" && url !== "/index.html") {
      const candidate = path.join(clientDir, url);
      if (
        candidate.startsWith(clientDir) &&
        fs.existsSync(candidate) &&
        fs.statSync(candidate).isFile()
      ) {
        serveStatic(candidate, res);
        return;
      }
    }

    const { html, stateScript } = render();
    const page = template
      .replace("<!--app-html-->", html)
      .replace("<!--app-state-->", stateScript);
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/html");
    res.end(page);
  };
}

const handler = await (isProd ? createProdHandler() : createDevHandler());

http.createServer(handler).listen(PORT, () => {
  console.log(`xote ssr template ready at http://localhost:${PORT}`);
});
```

- [ ] **Step 3: Commit**

```bash
git add templates/ssr/src/Server.res templates/ssr/server.mjs
git commit -m "Add SSR template: Server.res and server.mjs"
```

---

## Task 8: Verify SSR template builds and runs

**Files:**
- None (verification only)

- [ ] **Step 1: Install dependencies**

Run:
```bash
cd templates/ssr
npm install
```

Expected: completes without errors.

- [ ] **Step 2: Build ReScript**

Run:
```bash
npx rescript
```

Expected: exits 0. `src/Counter.res.mjs`, `src/App.res.mjs`, `src/Client.res.mjs`, `src/Server.res.mjs` all exist.

- [ ] **Step 3: Smoke-test the dev server**

Run:
```bash
npm run dev &
SERVER_PID=$!
sleep 4
BODY=$(curl -sf http://localhost:3000/)
kill $SERVER_PID
echo "$BODY" | grep -q 'id="root"'
echo "$BODY" | grep -q 'window.__XOTE_STATE__'
echo "$BODY" | grep -q '"count":0'
```

Expected: all three `grep` calls exit 0. The body shows the server-rendered counter markup, the SSR state script, and the initial `count` value.

- [ ] **Step 4: Build production bundles**

Run:
```bash
npm run build
```

Expected: exits 0. `dist/client/index.html` and `dist/server/Server.res.mjs` both exist.

- [ ] **Step 5: Smoke-test the production server**

Run:
```bash
NODE_ENV=production node server.mjs &
SERVER_PID=$!
sleep 2
BODY=$(curl -sf http://localhost:3000/)
kill $SERVER_PID
echo "$BODY" | grep -q 'id="root"'
echo "$BODY" | grep -q '"count":0'
```

Expected: both `grep` calls exit 0.

- [ ] **Step 6: Clean up build artifacts and return to repo root**

Run:
```bash
rm -rf templates/ssr/node_modules templates/ssr/dist
find templates/ssr -name '*.res.mjs' -delete
cd ../..
```

- [ ] **Step 7: Commit (no-op if nothing changed)**

If `git status` shows nothing, skip. Otherwise:

```bash
git add -A templates/ssr
git commit -m "Verify SSR template builds and serves"
```

---

## Self-review notes

- **Spec coverage:** README (Task 1), CSR scaffolding + source + verification (Tasks 2–4), SSR scaffolding + source + Server + verification (Tasks 5–8). Tailwind v4 via `@tailwindcss/vite` covered in both Vite configs and both `styles.css` files. SSR uses `SSRState.signal` per spec (Task 6). SSR rendering uses placeholder injection (`<!--app-html-->`, `<!--app-state-->`) per spec implementation note (Tasks 5 + 7).
- **Open assumption to validate during execution:** the exact ReScript v12 version string on npm — adjust the `^12.0.0-beta.1` constraint if a stable 12.x is published.
- **Open assumption to validate during execution:** that `vite build --ssr src/Server.res.mjs` resolves through ReScript's in-source ESM output. If Vite cannot resolve the ReScript-generated module imports during SSR build, the fix is to add `ssr.noExternal: ["xote", "rescript-signals"]` (or the equivalent) to `vite.config.mjs`. Apply only if the build fails.
