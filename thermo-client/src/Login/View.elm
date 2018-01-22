module Login.View exposing (view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput, onClick)

import Components.Tile.View as Tile exposing (view)
import Login.Types exposing (..)

view : Model -> Html Msg
view model =
  let
    bearerError =
      case model.bearerError of
        Nothing -> div [ style [("display", "none")] ] []
        Just error -> div [] [ text error ]
  in
  Tile.view [
      ("width", "33%")
    ]
    [ div []
      [ text "What is your bearer token?"
      , bearerError
      , input [ onInput UpdateBearer ] []
      , button [ onClick Login ] [ text "Login" ]
      ]
    ]

