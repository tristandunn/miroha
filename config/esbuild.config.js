const watch = process.argv.includes("--watch") && {

  /**
   * Log when a build is finished or failed.
   *
   * @param {Error|null} error The possible error.
   * @returns {void}
   */
  onRebuild(error) {
    if (error) {
      // eslint-disable-next-line no-console
      console.error("[watch] build failed", error);
    } else {
      console.log("[watch] build finished"); // eslint-disable-line no-console
    }
  }
};

require("esbuild").
  build({
    "bundle": true,
    "entryPoints": ["app/javascript/application.js"],
    "minify": process.env.NODE_ENV === "production",
    "outfile": "app/assets/builds/application.js",
    watch
  }).
  catch(() => {
    process.exit(1); // eslint-disable-line no-magic-numbers
  });
