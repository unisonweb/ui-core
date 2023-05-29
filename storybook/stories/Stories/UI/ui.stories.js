export default { title: "UI" };

import { initElmStory } from "../../initElmStory.js";
import Icon from "./Icon.elm";
import Button from "./Button.elm";
import Card from "./Card.elm";
import ErrorCard from "./ErrorCard.elm";
import Banner from "./Banner.elm";
import CopyField from "./CopyField.elm";
import "../../../../src/UI/CopyOnClick.js"; // webcomponent
import FoldToggle from "./FoldToggle.elm";
import KeyboardShortcut from "./KeyboardShortcut.elm";
import Modal from "./Modal.elm";
import Navigation from "./Navigation.elm";
import PlaceholderShape from "./PlaceholderShape.elm";
import StatusBanner from "./StatusBanner.elm";

export const banner = () => {
  return initElmStory(Banner.Elm.Stories.UI.Banner);
};
export const button = () => {
  return initElmStory(Button.Elm.Stories.UI.Button);
};
export const card = () => {
  return initElmStory(Card.Elm.Stories.UI.Card);
};
export const copyField = () => {
  return initElmStory(CopyField.Elm.Stories.UI.CopyField);
};
export const errorCard = () => {
  return initElmStory(ErrorCard.Elm.Stories.UI.ErrorCard);
};
export const foldToggle = () => {
  return initElmStory(FoldToggle.Elm.Stories.UI.FoldToggle);
};
export const icon = () => {
  return initElmStory(Icon.Elm.Stories.UI.Icon);
};
export const keyboardShortcut = () => {
  return initElmStory(KeyboardShortcut.Elm.Stories.UI.KeyboardShortcut);
};
export const modal = () => {
  return initElmStory(Modal.Elm.Stories.UI.Modal);
};
export const navigation = () => {
  return initElmStory(Navigation.Elm.Stories.UI.Navigation);
};
export const placeholderShape = () => {
  return initElmStory(PlaceholderShape.Elm.Stories.UI.PlaceholderShape);
};
export const statusBanner = () => {
  return initElmStory(StatusBanner.Elm.Stories.UI.StatusBanner);
};
