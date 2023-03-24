export default { title: "UI" };

import { initElmStory } from "./initElmStory.js";
import Icon from "./Stories/UI/Icon.elm";
import Button from "./Stories/UI/Button.elm";
import Card from "./Stories/UI/Card.elm";
import ErrorCard from "./Stories/UI/ErrorCard.elm";
import Banner from './Stories/UI/Banner.elm';
import CopyField from './Stories/UI/CopyField.elm';
import FoldToggle from './Stories/UI/FoldToggle.elm';
import KeyboardShortcut from './Stories/UI/KeyboardShortcut.elm';
import Modal from './Stories/UI/Modal.elm';
import Navigation from './Stories/UI/Navigation.elm';

export const icon = () => {
  return initElmStory(Icon.Elm.Stories.UI.Icon);
};

export const button = () => {
  return initElmStory(Button.Elm.Stories.UI.Button);
};

export const card = () => {
  return initElmStory(Card.Elm.Stories.UI.Card)
};

export const errorCard = () => {
  return initElmStory(ErrorCard.Elm.Stories.UI.ErrorCard)
};

export const banner = () => {
  return initElmStory(Banner.Elm.Stories.UI.Banner)
};

export const copyField = () => {
  return initElmStory(CopyField.Elm.Stories.UI.CopyField)
};

export const foldToggle = () => {
  return initElmStory(FoldToggle.Elm.Stories.UI.FoldToggle)
};

export const keyboardShortcut = () => {
  return initElmStory(KeyboardShortcut.Elm.Stories.UI.KeyboardShortcut)
};

export const modal = () => {
  return initElmStory(Modal.Elm.Stories.UI.Modal)
};

export const navigation = () => {
  return initElmStory(Navigation.Elm.Stories.UI.Navigation)
};
