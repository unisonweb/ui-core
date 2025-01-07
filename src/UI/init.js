import polyfill from '@oddbird/css-anchor-positioning/fn';

if (!("anchorName" in document.documentElement.style)) {
  polyfill();
}
