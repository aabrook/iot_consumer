module Readings.Room.View exposing (view)

import Date as Date exposing (fromString, day, month, hour, minute)

import Components.Tile.View as Tile exposing (view)
import Readings.Types exposing (Room)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import Date.Format exposing (format)

view : Room -> Html msg
view { temperature, room, date, humidity, status } =
  let
    getDate =
      date
      |> Maybe.map Date.fromString
      |> Maybe.andThen Result.toMaybe
      |> Maybe.map formatDate
      |> Maybe.withDefault ("Unknown")
      |> text
    formatDate =
      format "%Y-%m-%d %H:%M"
    getStatus =
      status
      |> Maybe.map .status
      |> Maybe.withDefault "Ok"
      |> text
  in
  Tile.view [("margin", "auto"), ("max-width", "10rem")]
    [ div [ style [("padding", "5px")] ] [ getDate ]
    , div [ style [("padding", "5px")] ] [ text "Room: ", text room ]
    , div [ style [("padding", "5px")] ] [ text "Temperature: ", temperature |> toString |> text ]
    , div [ style [("padding", "5px")] ] [ text "Humidity: ", humidity |> toString |> text ]
    , div [ style [("padding", "5px")] ] [ text "Status: ", getStatus ]
    ]
