import embed from 'vega-embed';

// <embed-vega-lite markup="some vega-lite specification">
// </embed-vega-lite>

class EmbedVegaLite extends HTMLElement {
  constructor() {
    super();
  }

  async connectedCallback() {
    const markup = this.getAttribute("markup");

    await embed(this, JSON.parse(markup));
  }
}

customElements.define("embed-vega-lite", EmbedVegaLite);
