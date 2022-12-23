const StorybookElmPlugin = require("./storybook-elm/plugin");
const { mergeConfig } = require("vite");

module.exports = {
  framework: "@storybook/html",
  core: { builder: "@storybook/builder-vite" },
  stories: ["../src/Stories/**/*.elm"],
  addons: [
    "./storybook-elm/addon/register",
    "@storybook/addon-actions",
    "@storybook/addon-a11y",
  ],
  async viteFinal(config) {
    // Automatically creates stories from .elm files
    config.plugins.push(StorybookElmPlugin());
    return mergeConfig(config, {
      server: { fs: { allow: [".."] } },
    });
  },
};
