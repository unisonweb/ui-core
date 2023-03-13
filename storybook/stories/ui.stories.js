export default { title: 'UI' }

import { initElmStory } from './initElmStory.js';
import Icon from './Stories/UI/Icon.elm';
import Button from './Stories/UI/Button.elm';

export const icon = () => {
    return initElmStory(Icon.Elm.Stories.UI.Icon);
}

export const button = () => {
    return initElmStory(Button.Elm.Stories.UI.Button);
}