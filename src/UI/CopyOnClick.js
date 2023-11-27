// <copy-on-click text="text-to-copy">
//   clickable content
// </copy-on-click>
class CopyOnClick extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    this.addEventListener("click", () => {
      const text = this.getAttribute("text");

      // writeText returns a promise with success/failure that we should
      // probably do something with...
      navigator.clipboard.writeText(text);
      this.classList.add("copy-success");
      setTimeout(() => {
        this.classList.remove("copy-success");
      }, 1500);
    });
  }

  static get observedAttributes() {
    return ["text"];
  }
}

customElements.define("copy-on-click", CopyOnClick);
