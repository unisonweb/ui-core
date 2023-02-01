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

    const diagramId = "mermaid-diagram_" + Date.now().toString();

    try {
      console.log("mermaid init");
      mermaid.mermaidAPI.initialize({
        theme: themeName,
        startOnLoad: false,
        securityLevel: "sandbox",
      });
      console.log("mermaid init done");

      // Generate a diagram id, so we can have more than 1 diagram on the page at
      // a time
      console.log("mermaid render");
      mermaid.render(diagramId, diagram, (svg) => {
        console.log("inner render callback");
        this.innerHTML = svg;
      });
    } catch (e) {
      console.error(e);
      this.innerHTML = "Error, could not render Mermaid Diagram";
      this.setAttribute("title", e.toString());
      document.getElementById("i" + diagramId)?.remove();
    }
  }
}

customElements.define("mermaid-diagram", MermaidDiagram);
