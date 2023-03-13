export default { title: 'Code' }

import { initElmStory } from './initElmStory.js';
import WorkspaceItem from './Stories/Code/WorkspaceItem.elm';

export const workspaceItem = () => {
    return initElmStory(WorkspaceItem.Elm.Stories.Code.WorkspaceItem);
}
