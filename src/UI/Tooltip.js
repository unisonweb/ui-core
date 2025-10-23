class Tooltip extends HTMLElement {
  constructor() {
    super();
  }

  async connectedCallback() {}
}

customElements.define("tool-tip", Tooltip);
