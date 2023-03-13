export default { title: 'views/UI' }

import { initElmStory } from '../../initElmStory.js';
import Icon from './Icon.elm';
import Button from './Button.elm';

export const icon = () => {
    return initElmStory(Icon.Elm.Icon);
}

export const button = () => {
    return initElmStory(Button.Elm.Button);
}