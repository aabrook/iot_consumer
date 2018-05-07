module Readings.Room.View exposing (view)

import Date as Date exposing (fromString, day, month, hour, minute)

import Components.Tile.View as Tile exposing (view)
import Readings.Types exposing (Room)
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import String exposing (padLeft)

view : Room -> Html msg
view { temperature, room, date, humidity } =
  let
    getDate =
      Date.fromString date
    formatDate d =
      (padLeft 2 '0' <| toString <| Date.day d) ++ "-" ++
      (toString <| Date.month d) ++ " " ++
      (padLeft 2 '0' <| toString <| Date.hour d) ++ ":" ++
      (padLeft 2 '0' <| toString <| Date.minute d)
    formattedDate =
      case getDate of
        Err _ -> text date
        Ok d -> text <| formatDate d
  in
  Tile.view [("margin", "auto"), ("max-width", "10rem")]
    [ div [ style [("padding", "5px")] ] [ formattedDate ]
    , div [ style [("padding", "5px")] ] [ text "Room: ", text room ]
    , div [ style [("padding", "5px")] ] [ text "Temperature: ", temperature |> toString |> text ]
    , div [ style [("padding", "5px")] ] [ text "Humidity: ", humidity |> toString |> text ]
    ]
