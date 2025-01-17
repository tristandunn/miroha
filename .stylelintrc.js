export default {
  "extends": ["stylelint-config-standard"],

  "rules": {
    "at-rule-no-deprecated": [
      true,
      {
        "ignoreAtRules": ["apply"]
      }
    ],
    "at-rule-no-unknown": [
      true,
      {
        "ignoreAtRules": ["tailwind"]
      }
    ],
    "import-notation": "string"
  }
};
