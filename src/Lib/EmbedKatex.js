// <embed-katex markup="some katex markup" display="block">
// </embed-katex>
class EmbedKatex extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if (katex) {
      this.render();
    }
  }

  render() {
    const markup = this.getAttribute("markup");
    const display = this.getAttribute("display");

    katex.render(markup, this, {
      throwOnError: false,
      displayMode: display === "block",
    });
  }
}

customElements.define("embed-katex", EmbedKatex);
