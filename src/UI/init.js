import polyfill from '@oddbird/css-anchor-positioning/fn';

export function init() {
  if (!("anchorName" in document.documentElement.style)) {
    console.log("Adding Anchor Positioning polyfill");
    polyfill();
  }
}
