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

    // Generate a unique-ish diagram id, so we can have more than 1 diagram on
    // the page at a time
    const diagramId = "mermaid-diagram_" + Date.now().toString();

    try {
      mermaid.mermaidAPI.initialize({
        theme: themeName,
        startOnLoad: false,
        securityLevel: "sandbox",
      });

      mermaid.render(diagramId, diagram, (svg) => {
        this.innerHTML = svg;
      });
    } catch (e) {
      this.innerHTML =
        "⚠️  Unfortunately, the Mermaid diagram could not be rendered.";
      this.classList.add("mermaid-diagram mermaid-diagram_error");
      this.setAttribute("title", e.toString());

      // When Mermaid fails, it sometimes leaves an orphaned iframe at the end
      // of <body>. Remove it.
      document.getElementById("i" + diagramId)?.remove();
    }
  }
}

customElements.define("mermaid-diagram", MermaidDiagram);
