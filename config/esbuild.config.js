/* global process */

import esbuild from "esbuild";

(async () => {
  const context = await esbuild.context({
    "bundle": true,
    "entryPoints": ["app/javascript/application.js"],
    "logLevel": "debug",
    "minify": process.env.NODE_ENV === "production",
    "outfile": "app/assets/builds/application.js"
  });

  if (process.argv.includes("--watch")) {
    await context.watch();
  } else {
    await context.rebuild();

    context.dispose();
  }
})();
