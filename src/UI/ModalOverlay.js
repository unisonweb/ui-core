// Common modal WebComponent for both AnchoredOverlay and Modal
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
      evt.preventDefault();
      evt.stopPropagation();

      this.dispatchEvent(new CustomEvent('escape'));
    }
  }

  connectedCallback() {
    this.focus();

    this.addEventListener("keydown", onKeydown);
  }

  disconnectedCallback() {
    this.removeEventListener("keydown", this.onMouseDown);
  }
}

customElements.define("modal-overlay", ModalOverlay);
