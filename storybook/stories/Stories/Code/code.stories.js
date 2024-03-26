export default { title: "Code" };

import { initElmStory } from "../../initElmStory.js";
import WorkspaceItem from "./WorkspaceItem.elm";
import Workspace from "./Workspace.elm";
import WorkspaceMinimap from "./WorkspaceMinimap.elm";
import PageContent from "./PageContent.elm";

export const workspace = () => {
  return initElmStory(Workspace.Elm.Stories.Code.Workspace);
};

export const workspaceItem = () => {
  return initElmStory(WorkspaceItem.Elm.Stories.Code.WorkspaceItem);
};

export const workspaceMinimap = () => {
  return initElmStory(WorkspaceMinimap.Elm.Stories.Code.WorkspaceMinimap);
};

export const pageContent = () => {
  return initElmStory(PageContent.Elm.Stories.Code.PageContent);
};
