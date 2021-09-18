module.exports = {
  "exclude": /node_modules/u,
  "test": /\.ya?ml/u,
  "type": "json",
  "use": [{ "loader": "yaml-loader" }]
};
