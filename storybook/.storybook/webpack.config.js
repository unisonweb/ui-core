const path = require("path");

module.exports = async ({ config, mode }) => {
  config.resolve.extensions.push(".elm");

  config.module.rules.push({
    test: /\.elm$/,
    exclude: [/elm-stuff/, /node_modules/],
    loader: "elm-webpack-loader",
    options: {
      debug: mode === 'DEVELOPMENT',
    },
  });

  return config;
};
