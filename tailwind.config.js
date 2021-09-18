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
    "fontFamily": {
      "sans": ["Inter", ...fontFamily.sans]
    }
  }
};
