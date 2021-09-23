module.exports = {
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": ["eslint:all"],
  "parser": "babel-eslint",
  "parserOptions": {
    "sourceType": "module"
  },
  "rules": {
    "array-element-newline": ["error", "consistent"],
    "arrow-body-style": ["error", "always"],
    "function-call-argument-newline": ["error", "consistent"],
    "function-paren-newline": ["error", "consistent"],
    "indent": ["error", 2], /* eslint no-magic-numbers: 0 */
    "lines-around-comment": ["error", { "allowClassStart": true }],
    "no-magic-numbers": ["error", { "ignore": [0] }],
    "object-curly-spacing": ["error", "always"],
    "padded-blocks": "off",
    "sort-vars": "off",
    "space-before-function-paren": "off"
  }
};
