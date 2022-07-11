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
      const isOutside = !document
        .getElementById("on-click-outside")
        .contains(e.target);

      if (isOutside) {
        var event = new CustomEvent("clickOutside");
        this.dispatchEvent(event);
      }
    };

    window.addEventListener("mousedown", this.onMouseDown);
  }

  disconnectedCallback() {
    window.removeEventListener("mousedown", this.onMouseDown);
  }
}

customElements.define("click-outside", OnClickOutside);
