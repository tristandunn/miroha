module.exports = {
  "env": {
    "browser": true,
    "es2021": true,
    "mocha": true,
    "node": true
  },
  "extends": ["eslint:all"],
  "globals": {
    "expect": true,
    "sinon": true
  },
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
    "object-curly-spacing": ["error", "always"],
    "padded-blocks": ["error", "never"]
  }
};
