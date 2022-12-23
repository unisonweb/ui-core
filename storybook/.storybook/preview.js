import "../static/style.css";
import "../../src/css/ui.css";

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  options: {
    storySort: {
      order: [
        "Basics",
        ["Typography"],
        "Layout",
        ["Row", "Column"],
        "Button",
        ["Primary", "Secondary", "Danger", "Disabled"],
      ],
    },
  },
};
