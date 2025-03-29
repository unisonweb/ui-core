// Displays the copyright symbol and the current year.
// example:
//   <copyright-year></copyright-year>
//
//   ⧨
//
//   © 2023
//
//
class CopyrightYear extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    const d = new Date();
    this.innerText = `© ${d.getFullYear()}`;
    this.classList.add("copyright-year");
  }
}

customElements.define("copyright-year", CopyrightYear);
