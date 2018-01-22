module Readings.View exposing (view)

import Maybe exposing (withDefault)

import Html exposing (Html, button, text, div, h1, img, input, select, option)
import Html.Events exposing (onInput, onClick, on)
import Readings.Types exposing (Model, Msg(..))
import Readings.Room.View as Room exposing (view)

view : Model -> Html Msg
view model =
  let
    room =
      case model.roomResult of
        Nothing -> text "Select a room!"
        Just room -> Room.view room
    error = text <| withDefault "" model.error
  in
    div []
      [
        button [ onClick ListRooms ] [ text "List Rooms" ]
      , div []
        [ text "Which room?"
        , select [ onInput UpdateRoom ] <| List.map (\r -> option [] [ text r ])  <| "" :: model.roomList
        ]
      , button [ onClick QueryRoom ] [ text "Query Room" ]
      , room
      , div []
        [ error
        ]
      ]
