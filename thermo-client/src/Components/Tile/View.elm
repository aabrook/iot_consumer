module Components.Tile.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (style)

view : List (String, String) -> List (Html msg) -> Html msg
view styles
  = div [
      style <|
      [ ("display", "block")
      , ("margin", "auto")
      , ("padding", "1rem")
      , ("border-radius", "0.5rem")
      , ("box-shadow", "0.2rem 0.2rem #EEE")
      , ("border", "0.05rem solid #EEE")
      ] ++ styles
    ]
