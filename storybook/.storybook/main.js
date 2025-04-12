const postcssPresetEnv = require("postcss-preset-env");
const UI_CORE_SRC = "../src";

module.exports = {
  stories: ["../stories/**/*.mdx", "../stories/**/*.stories.@(js|jsx|ts|tsx)"],

  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-interactions",
    "storybook-dark-mode",
    "storybook-css-modules-preset",
    {
      name: "@storybook/addon-styling",
      options: {
        // These rules are the same as ones in unison-local-ui/webpack.dev.js
        cssBuildRule: {
          test: /\.css$/i,
          use: [
            "style-loader",
            {
              loader: "css-loader",
              options: { importLoaders: 1 },
            },
            {
              loader: "postcss-loader",
              options: {
                postcssOptions: {
                  plugins: [
                    postcssPresetEnv({
                      features: {
                        "is-pseudo-class": false,
                        "custom-media-queries": {
                          importFrom: `${UI_CORE_SRC}/css/ui/viewport.css`,
                        },
                      },
                    }),
                  ],
                },
              },
            },
          ],
        },
      },
    },
    "@storybook/addon-webpack5-compiler-babel",
    "@chromatic-com/storybook"
  ],

  framework: {
    name: "@storybook/html-webpack5",
    options: {},
  },

  staticDirs: ["../static"],

  docs: {},
};
