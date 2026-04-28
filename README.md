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
