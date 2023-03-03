export default { title: 'views/UI' }

import { initElmStory } from '../../initElmStory.js';
import Icon from './Icon.elm';

export const icon = () => {
    return initElmStory(Icon.Elm.Main);
}
