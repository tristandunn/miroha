export default {
  "extends": ["stylelint-config-standard"],

  "rules": {
    "at-rule-no-deprecated": null,
    "at-rule-no-unknown": [
      true,
      {
        "ignoreAtRules": ["apply", "plugin"]
      }
    ],
    "import-notation": "string"
  }
};
