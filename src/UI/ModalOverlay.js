// Common modal WebComponent for both AnchoredOverlay and Modalmodal
// which adds keyboard shortcuts and focus
//
// <modal-overlay on-escape="..." on-enter="...">
//   modal content
// </modal-overlay>
class ModalOverlay extends HTMLElement {
  static get observedAttributes() {
    return ["text"];
  }

  constructor() {
    super();
  }

  onKeydown(ev) {
    if (ev.key === "Escape") {
      ev.preventDefault();
      ev.stopPropagation();

      this.dispatchEvent(new CustomEvent('escape'));
    }
  }

  connectedCallback() {
    this.firstChild.focus();

    this.addEventListener("keydown", this.onKeydown);
  }

  disconnectedCallback() {
    this.removeEventListener("keydown", this.onKeydown);
  }
}

customElements.define("modal-overlay", ModalOverlay);
