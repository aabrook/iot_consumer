module Login.View exposing (view)

import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput, onClick)

import Components.Tile.View as Tile exposing (view)
import Login.Types exposing (..)

view : Model -> Html Msg
view model =
  let
    bearerError =
      case model.bearerError of
        Nothing -> span [ style [("display", "none")] ] []
        Just error -> span [ style [("padding-left", "10px"), ("color", "red")] ] [ text error ]
  in
  Tile.view [
      ("width", "33%")
    ]
    [ div []
      [ text "What is your bearer token?"
      , div []
        [ input [ onInput UpdateBearer ] []
        , bearerError
        ]
      , button [ onClick Login ] [ text "Login" ]
      ]
    ]

