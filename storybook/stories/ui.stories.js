export default { title: 'UI' }

import { initElmStory } from './initElmStory.js';
import Icon from './UIStories/Icon.elm';
import Button from './UIStories/Button.elm';

export const icon = () => {
    return initElmStory(Icon.Elm.UIStories.Icon);
}

export const button = () => {
    return initElmStory(Button.Elm.UIStories.Button);
}