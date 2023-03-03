import '../../src/css/code.css'
import '../../src/css/ui.css'
import '../../src/css/ui/core.css'
import "../../src/css/themes/unison-light.css";

export const parameters = {
  actions: { argTypesRegex: "^on[A-Z].*" },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/,
    },
  },
}