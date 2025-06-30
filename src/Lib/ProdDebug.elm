{- This requires a port subscription by the host application.

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


port module Lib.ProdDebug exposing (..)


port debugLog : String -> Cmd msg
