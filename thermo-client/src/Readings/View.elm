module Readings.View exposing (view)

import Html exposing (Html, button, text, div, h1, img, input, select, option)
import Html.Events exposing (onInput, onClick, on)
import Http exposing (..)
import Readings.Types exposing (Model, Msg(..))

view : Model -> Html Msg
view model =
  div []
    [
      button [ onClick ListRooms ] [ text "List Rooms" ]
    , div []
      [ text "Which room?"
      , select [ onInput UpdateRoom ] <| List.map (\r -> option [] [ text r ])  <| "" :: model.roomList
      ]
    , button [ onClick QueryRoom ] [ text "Query Room" ]
    , div []
      [ text model.roomResult
      ]
    ]
