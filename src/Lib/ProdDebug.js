// <prod-debug message="debug message"></prod-debug>

class ProdDebug extends HTMLElement {
  static get observedAttributes() {
    return ["message"];
  }

  constructor() {
    super();
  }

  connectedCallback() {
    this.log();
  }

  attributeChangedCallback() {
    this.log();
  }

  log() {
    const message = this.getAttribute("message");
    console.debug(message);
  }
}

customElements.define("prod-debug", ProdDebug);
