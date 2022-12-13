import katex from "katex";
import "katex/dist/katex.min.css";

// <embed-katex markup="some latex notation" display="block">
// </embed-katex>

class EmbedKatex extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    const markup = this.getAttribute("markup");
    const display = this.getAttribute("display");

    katex.render(markup, this, {
      throwOnError: false,
      displayMode: display === "block",
    });
  }
}

customElements.define("embed-katex", EmbedKatex);
