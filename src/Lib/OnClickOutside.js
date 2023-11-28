// <on-click-outside>
//   <div clicking outside this div fires the `clickOutside` event.</div>
// </on-click-outside>
//
class OnClickOutside extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    this.onMouseDown = (e) => {
      const style = window.getComputedStyle(this);

      // If the element isn't visible, there's no point in triggering the
      // clickoutside event. This is useful when multiple variants of a
      // clickoutside is active for the same UI (one for desktop and one for
      // mobile for instance).
      if (style.display === 'none') {
        return;
      }

      const isOutside = !document
        .getElementById("on-click-outside")
        .contains(e.target)

      if (isOutside) {
        const event = new CustomEvent("clickOutside");
        this.dispatchEvent(event);
      }
    };

    window.addEventListener("mousedown", this.onMouseDown);
  }

  disconnectedCallback() {
    window.removeEventListener("mousedown", this.onMouseDown);
  }
}

customElements.define("on-click-outside", OnClickOutside);
