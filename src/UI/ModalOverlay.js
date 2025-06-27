// Common modal WebComponent for both AnchoredOverlay and Modal
// which adds keyboard shortcuts.
//
// <modal-overlay focusClassName="modal" on-escape="...">
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
    this.setFocus();

    // TODO, handle nested overlays better. Like if an AnchoredOverlay is
    // inside of a Modal, we'd want the AnchoredOverlay to be dismissed, not
    // the modal (unless no AnchoredOverlay is open)
    this.onKeydown = (ev) => {
      // If the element isn't visible, there's no point in triggering the keyboard event.
      const style = window.getComputedStyle(this);
      if (style.display === "none" || this.offsetParent === null) {
        return;
      }

      if (this.hasAttribute("has-esc-handler") && ev.key === "Escape") {
        ev.preventDefault();
        ev.stopPropagation();

        this.dispatchEvent(new CustomEvent("escape"));
      }

      if (this.hasAttribute("has-enter-handler") && ev.key === "Enter") {
        ev.preventDefault();
        ev.stopPropagation();

        this.dispatchEvent(new CustomEvent("enter"));
      }
    };

    window.addEventListener("keydown", this.onKeydown);
  }

  disconnectedCallback() {
    window.removeEventListener("keydown", this.onKeydown);
  }

  setFocus() {
    // Autofocus only actually work on page load, so we check for its existence
    // in modals and trigger focus.
    const autofocused = this.querySelector("[autofocus]");
    if (autofocused) {
      autofocused.focus();
    } else {
      const focusClassName = this.getAttribute("focusClassName");
      if (focusClassName) {
        this.querySelector(focusClassName)?.focus();
      } else {
        this.firstChild?.focus();
      }
    }
  }
}

customElements.define("modal-overlay", ModalOverlay);
