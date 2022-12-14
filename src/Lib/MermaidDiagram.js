import mermaid from "mermaid";

// <mermaid-diagram diagram="mermaid diagram definition" themeName="neutral">
// </mermaid-diagram>

class MermaidDiagram extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    const diagram = this.getAttribute("diagram");
    const themeName = this.getAttribute("theme-name");

    mermaid.mermaidAPI.initialize({
      theme: themeName,
      startOnLoad: false,
      securityLevel: "sandbox",
    });

    // Generate a diagram id, so we can have more than 1 diagram on the page at
    // a time
    const diagramId = Date.now().toString();
    mermaid.render("mermaid-diagram_" + diagramId, diagram, (svg) => {
      this.innerHTML = svg;
    });
  }
}

customElements.define("mermaid-diagram", MermaidDiagram);
