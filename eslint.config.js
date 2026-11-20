import js from "@eslint/js";
import stylistic from "@stylistic/eslint-plugin";

export default [
  {
    "ignores": [
      "app/assets/builds/**",
      "app/assets/config/manifest.js",
      "node_modules/**",
      "vendor/**"
    ]
  },
  {
    "files": ["**/*.js"],
    "languageOptions": {
      "globals": {
        "document": "readonly",
        "module": "readonly",
        "require": "readonly",
        "window": "readonly"
      },
      "parserOptions": {
        "sourceType": "module"
      }
    },
    "plugins": {
      "@stylistic": stylistic
    },
    "rules": {
      ...js.configs.recommended.rules,
      ...stylistic.configs["all"].rules,

      "arrow-body-style": ["error", "always"],
      "no-magic-numbers": ["error", { "ignore": [0, 1] }],

      "@stylistic/indent": ["error", 2], /* eslint-disable-line no-magic-numbers */
      "@stylistic/lines-around-comment": ["error", { "allowClassStart": true }],
      "@stylistic/padded-blocks": "off",
      "@stylistic/space-before-function-paren": "off"
    }
  },
  {
    "files": ["spec/**/*.js"],
    "languageOptions": {
      "globals": {
        "afterEach": "readonly",
        "beforeEach": "readonly",
        "context": "readonly",
        "describe": "readonly",
        "expect": "readonly",
        "global": "readonly",
        "it": "readonly",
        "sinon": "readonly"
      }
    },
    "rules": {
      "no-magic-numbers": "off"
    }
  }
];
