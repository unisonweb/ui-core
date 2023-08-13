module.exports = {
  stories: [
    "../stories/**/*.stories.mdx",
    "../stories/**/*.stories.@(js|jsx|ts|tsx)",
  ],

  addons: [
    "@storybook/addon-links",
    "@storybook/addon-essentials",
    "@storybook/addon-interactions",
    'storybook-dark-mode',
  ],

  framework: {
    name: "@storybook/html-webpack5",
    options: {}
  },

  staticDirs: ["../static"],

  docs: {
    autodocs: true
  }
};
