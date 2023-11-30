// Common modal WebComponent for both AnchoredOverlay and Modalmodal
// which adds keyboard shortcuts.
//
// <modal-overlay on-escape="...">
//   modal content
// </modal-overlay>
class ModalOverlay extends HTMLElement {
  static get observedAttributes() {
    return ["text"];
  }

  constructor() {
    super();
  }

  connectedCallback() {
    this.onKeydown = (ev) => {
      // If the element isn't visible, there's no point in triggering the escape event.
      const style = window.getComputedStyle(this);
      if (style.display === "none" || this.offsetParent === null) {
        return;
      }

      if (ev.key === "Escape") {
        ev.preventDefault();
        ev.stopPropagation();

        this.dispatchEvent(new CustomEvent("escape"));
      }
    };

    window.addEventListener("keydown", this.onKeydown);
  }

  disconnectedCallback() {
    window.removeEventListener("keydown", this.onKeydown);
  }
}

customElements.define("modal-overlay", ModalOverlay);
