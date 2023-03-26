module.exports = {
  "env": {
    "mocha": true
  },
  "globals": {
    "expect": true,
    "sinon": true
  },
  "rules": {
    "init-declarations": "off",
    "max-lines": "off",
    "max-lines-per-function": "off",
    "max-statements": "off",
    "no-magic-numbers": ["error", { "ignore": [0, 1, 999] }],
    "no-unused-expressions": "off"
  }
};
