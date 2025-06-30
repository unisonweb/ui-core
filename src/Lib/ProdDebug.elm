port module Lib.ProdDebug exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


view : String -> List (Html msg) -> Html msg
view debugMessage content =
    node "prod-debug" [ attribute "message" debugMessage ] content


{-| This requires a port subscription by the host application.

Something like:

```javascript
const app = Elm.HostApp.init({ flags });

if (app.ports) {
  app.ports.debugLog?.subscribe((text) => {
    console.debug(text);
  });
}
```

-}
port debugLog : String -> Cmd msg
