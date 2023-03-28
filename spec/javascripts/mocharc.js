module.exports = {
  "exit": true,
  "recursive": true,
  "reporter": "dot",
  "require": [
    "@babel/register",
    "spec/javascripts/helpers.js",
    "spec/javascripts/helpers/hooks.js"
  ]
};
