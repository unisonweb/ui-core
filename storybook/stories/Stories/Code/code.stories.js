export default { title: "Code" };

import { initElmStory } from "../../initElmStory.js";
import WorkspaceItem from "./WorkspaceItem.elm";
import Workspace from "./Workspace.elm";

export const workspaceItem = () => {
  return initElmStory(WorkspaceItem.Elm.Stories.Code.WorkspaceItem);
};

export const workspace = () => {
  return initElmStory(Workspace.Elm.Stories.Code.Workspace);
};