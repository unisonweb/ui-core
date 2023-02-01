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

    const diagramId = Date.now().toString();

    try {
      mermaid.mermaidAPI.initialize({
        theme: themeName,
        startOnLoad: false,
        securityLevel: "sandbox",
      });

      // Generate a diagram id, so we can have more than 1 diagram on the page at
      // a time
      mermaid.render("mermaid-diagram_" + diagramId, diagram, (svg) => {
        this.innerHTML = svg;
      });
    } catch (e) {
      this.innerHTML = "Error, could not render Mermaid Diagram";
      this.setAttribute("title", e.toString());
    }
  }
}

customElements.define("mermaid-diagram", MermaidDiagram);
