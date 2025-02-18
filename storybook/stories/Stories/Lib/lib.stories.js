export default { title: "Lib" };

import { initElmStory } from "../../initElmStory.js";
import "../../../../src/Lib/MermaidDiagram.js"; // webcomponent
import MermaidDiagram from "./MermaidDiagram.elm";

export const mermaid = () => {
  return initElmStory(MermaidDiagram.Elm.Stories.Lib.MermaidDiagram);
};
