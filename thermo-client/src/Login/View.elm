module Login.View exposing (view)

import Html exposing (Html, button, div, input, text)
import Html.Events exposing (onInput, onClick)

import Login.Types exposing (..)

view : Model -> Html Msg
view model =
  div []
    [ text "What is your bearer token?"
    , input [ onInput UpdateBearer ] []
    , button [ onClick Login ] [ text "Login" ]
    ]

