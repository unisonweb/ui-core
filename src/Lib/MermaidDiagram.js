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
        const iframe = this.querySelector("iframe");
        iframe?.classList?.add("mermaid-diagram");
      });
    } catch (e) {
      const err = document.createElement("div");

      err.textContent =
        "🆘 Unfortunately, the Mermaid diagram could not be rendered.";
      err.classList.add("mermaid-diagram");
      err.classList.add("mermaid-diagram_error");
      err.setAttribute("title", e.toString());

      this.appendChild(err);

      // When Mermaid fails, it sometimes leaves an orphaned iframe at the end
      // of <body>. Remove it.
      document.getElementById("i" + diagramId)?.remove();

      // Rethrow error so we can ensure we log it.
      throw e;
    }
  }
}

customElements.define("mermaid-diagram", MermaidDiagram);
