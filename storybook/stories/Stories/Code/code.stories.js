export default { title: "Code" };

import { initElmStory } from "../../initElmStory.js";
import WorkspaceItem from "./WorkspaceItem.elm";
import Readme from "./Readme.elm";

export const workspaceItem = () => {
  return initElmStory(WorkspaceItem.Elm.Stories.Code.WorkspaceItem);
};

export const readme = () => {
  return initElmStory(Readme.Elm.Stories.Code.Readme);
}