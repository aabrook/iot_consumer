module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)

type Route
  = AuthRoute
  | RoomRoute
  | NotFoundRoute

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map AuthRoute top
    , map RoomRoute (s "rooms")
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute

roomPath : String
roomPath = "#rooms"

