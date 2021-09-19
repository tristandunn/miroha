const { fontFamily } = require("tailwindcss/defaultTheme");

module.exports = {
  "future": {
    "defaultLineHeights": true,
    "purgeLayersByDefault": true,
    "removeDeprecatedGapUtilities": true,
    "standardFontWeights": true
  },

  "plugins": [require("@tailwindcss/custom-forms")],

  "purge": {
    "content": [
      "./app/assets/javascripts/**/*.js",
      "./app/**/*.html.erb"
    ],
    "enabled": process.env.NODE_ENV === "production"
  },

  "theme": {
    "extend": {
      "boxShadow": require("./app/assets/javascripts/tailwind/box_shadow")
    },

    "fontFamily": {
      "sans": ["Inter", ...fontFamily.sans]
    }
  }
};
