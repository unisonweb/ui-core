export default { title: "Code" };

import { initElmStory } from "../../initElmStory.js";
import WorkspaceItem from "./WorkspaceItem.elm";

export const workspaceItem = () => {
  return initElmStory(WorkspaceItem.Elm.Stories.Code.WorkspaceItem);
};
