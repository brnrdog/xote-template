# xote templates

Two starter templates for building reactive web apps with [xote](https://github.com/brnrdog/xote).

| Template | Path | Use when |
| --- | --- | --- |
| **CSR** (client-only) | [`templates/csr`](./templates/csr) | You want a SPA — render in the browser, deploy as static files. |
| **SSR** (server-rendered) | [`templates/ssr`](./templates/ssr) | You want HTML rendered on a Node server with full client hydration. |

Both share the same stack and ship with the same friendly landing page and a small reactive counter demo, so you can compare side by side.

## Tech stack

- **[ReScript](https://rescript-lang.org/) v12** — a strongly-typed language that compiles to clean JavaScript. Templates use the JSX v4 transform.
- **[xote](https://www.npmjs.com/package/xote)** — a small, fine-grained reactive view library. No virtual DOM. The SSR template additionally uses xote's `SSR` and `Hydration` modules.
- **[rescript-signals](https://github.com/brnrdog/rescript-signals)** — the underlying reactive primitives (`Signal`, `Computed`, `Effect`).
- **[Vite](https://vitejs.dev/) 7** — dev server and bundler. The SSR template runs Vite in middleware mode so the same server handles HTML, assets, and SSR.
- **[Tailwind CSS](https://tailwindcss.com/) v4** — utility-first CSS via `@tailwindcss/vite`. CSS-first configuration; no `tailwind.config.js`.

## Quickstart

Pick a template, copy it out, install, and run.

```bash
# CSR
cp -r templates/csr my-app && cd my-app
npm install
npm run res:dev   # in one terminal — keeps ReScript compiling on save
npm run dev       # in another — Vite dev server

# SSR
cp -r templates/ssr my-app && cd my-app
npm install
npm run res:dev   # in one terminal
npm run dev       # in another — Node + Vite middleware
```

Open the URL Vite prints. You should see the welcome page with a reactive counter.

See each template's own `README.md` for details and scripts.
