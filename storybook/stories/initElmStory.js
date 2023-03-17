export const initElmStory = (elmApp) => {
  const containerDiv = document.createElement("div");
  const innerDiv = document.createElement("div");

  containerDiv.appendChild(innerDiv);
  elmApp.init({
    node: innerDiv,
  });
  return containerDiv;
};
