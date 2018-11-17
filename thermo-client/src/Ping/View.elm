module Ping.View exposing (view)

import Maybe exposing (withDefault)

import Html exposing (Html, button, text, div, h1, img, input, select, option)
import Html.Attributes exposing (style)
import Html.Events exposing (onInput, onClick, on)
import Ping.Types exposing (Model, Msg(..))
import Components.Tile.View as Tile exposing (view)

view : Model -> Html Msg
view model =
  let
    error = text <| withDefault "" model.error
    view { time, source, destination, ttl, insertedAt, updatedAt } =
      Tile.view [("margin", "auto"), ("max-width", "10rem")]
      [ div [ style [("padding", "5px")] ] [ text time ]
      , div [ style [("padding", "5px")] ] [ text ttl ]
      , div [ style [("padding", "5px")] ] [ text insertedAt ]
      , div [ style [("padding", "5px")] ] [ text updatedAt ]
      , div [ style [("padding", "5px")] ] [ text source ]
      , div [ style [("padding", "5px")] ] [ text destination ]
      ]
  in
    div []
      [
        button [ onClick ListPings ] [ text "List Pings" ]
      , div [
        style [ ("margin", "auto")
              , ("max-width", "21rem")
              , ("display", "flex")
              , ("flex-flow", "row wrap")
              ]
        ] <| List.map view model.pings
      , div []
        [ error
        ]
      ]
