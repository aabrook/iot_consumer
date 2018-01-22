module Readings.Room.View exposing (view)

import Components.Tile.View as Tile exposing (view)
import Readings.Types exposing (Room)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

view : Room -> Html msg
view { temperature, room }=
  Tile.view [("margin", "auto"), ("width", "10rem")]
    [ div [ style [("padding", "5px")] ] [ text "Room: ", text room ]
    , div [ style [("padding", "5px")] ] [ text "Temperature: ", text temperature ]
    ]
