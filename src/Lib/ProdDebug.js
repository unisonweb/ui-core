// <prod-debug message="debug message"></prod-debug>

class ProdDebug extends HTMLElement {
  constructor() {
    super();
  }

  async connectedCallback() {
    const message = this.getAttribute("message");
    console.debug(message);
  }
}

customElements.define("prod-debug", ProdDebug);
