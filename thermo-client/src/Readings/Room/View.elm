module Readings.Room.View exposing (view)

import Date as Date exposing (fromString, day, month, hour, minute)

import Components.Tile.View as Tile exposing (view)
import Readings.Types exposing (Room)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import String exposing (padLeft)

view : Room -> Html msg
view { temperature, room, date, humidity, status } =
  let
    getDate =
      date
      |> Maybe.map Date.fromString
      |> Maybe.map formattedDate
      |> Maybe.withDefault ("Unknown")
      |> text
    formatDate d =
      (padLeft 2 '0' <| toString <| Date.day d) ++ "-" ++
      (toString <| Date.month d) ++ " " ++
      (padLeft 2 '0' <| toString <| Date.hour d) ++ ":" ++
      (padLeft 2 '0' <| toString <| Date.minute d)
    formattedDate date =
      case date of
        Err _ -> "Bad Date"
        Ok d -> formatDate d
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
