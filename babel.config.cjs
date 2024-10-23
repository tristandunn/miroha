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
      isTestEnv && "babel-plugin-dynamic-import-node",
      isTestEnv && "babel-plugin-istanbul",
      "@babel/plugin-transform-destructuring",
      [
        "@babel/plugin-transform-class-properties",
        { "loose": true }
      ],
      [
        "@babel/plugin-transform-object-rest-spread",
        { "useBuiltIns": true }
      ],
      ["@babel/plugin-transform-private-property-in-object", { "loose": true }],
      ["@babel/plugin-transform-private-methods", { "loose": true }],
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
