export default { title: 'views/Home/Desktop' }

import { initElmStory } from '../../initElmStory.js';
import Home from './Home.elm';

export const normal = () => {
    return initElmStory(Home.Elm.Main);
}
