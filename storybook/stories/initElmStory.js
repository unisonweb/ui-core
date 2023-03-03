// Elm initializiation with Browser.app means that any existing content inside
// a document's body tag will get replaced by Elm.
// Storybook has an expectation that story content is inside div#root which
// is a child of body. There are also some other Storybook wrapper divs that
// we want to preserve.
// 1. Clone the original body without Elm
// 2. Init elm
// 3. Clone the body with Elm.
// 4. Reinstate the original body that we cloned.
// 5. Append Elm clone to div#root.
export const initElmStory = (elmApp) => {
    const body = document.querySelector('body')
    const originalCopy = body.cloneNode(true);
    const app = elmApp.init();
    const withElmCopy = body.cloneNode(true);
    body.parentNode.replaceChild(originalCopy, body);
    const rootDiv = document.querySelector('#root');
    rootDiv.innerHTML = '';
    rootDiv.appendChild(withElmCopy);
    return document.createElement('div');
};
