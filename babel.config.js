/* eslint-disable complexity */

module.exports = function babel (api) {
  const currentEnv = api.env(),
    isDevelopmentEnv = api.env("development"),
    isProductionEnv = api.env("production"),
    isTestEnv = api.env("test"),
    validEnv = ["development", "test", "production"];

  if (!validEnv.includes(currentEnv)) {
    throw new Error("Please specify a valid `NODE_ENV` or `BABEL_ENV`" +
      "environment variables: `development`, `test`, or `production`.");
  }

  return {
    "plugins": [
      "babel-plugin-macros",
      "@babel/plugin-syntax-dynamic-import",
      isTestEnv && "babel-plugin-dynamic-import-node",
      isTestEnv && "babel-plugin-istanbul",
      "@babel/plugin-transform-destructuring",
      [
        "@babel/plugin-proposal-class-properties",
        { "loose": true }
      ],
      [
        "@babel/plugin-proposal-object-rest-spread",
        { "useBuiltIns": true }
      ],
      ["@babel/plugin-proposal-private-property-in-object", { "loose": true }],
      ["@babel/plugin-proposal-private-methods", { "loose": true }],
      ["@babel/plugin-transform-runtime", { "helpers": false }],
      ["@babel/plugin-transform-regenerator", { "async": false }]
    ].filter(Boolean),

    "presets": [
      isTestEnv && ["@babel/preset-env", { "targets": { "node": "current" } }],
      (isProductionEnv || isDevelopmentEnv) && [
        "@babel/preset-env",
        {
          "corejs": 3,
          "exclude": ["transform-typeof-symbol"],
          "forceAllTransforms": true,
          "modules": false,
          "useBuiltIns": "entry"
        }
      ]
    ].filter(Boolean)
  };
};
