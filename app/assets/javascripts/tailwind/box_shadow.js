const { colors } = require("tailwindcss/defaultTheme");
const { map, reduce } = require("lodash");

module.exports = reduce(colors, (result, shades, color) => {
  if (typeof shades === "object") {
    map(shades, (value, shade) => {
      result[`${color}-${shade}`] = `0 0 0 3px ${value}`;
    });
  }

  return result;
}, {});
