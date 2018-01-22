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
    [ map RoomRoute (s "rooms")
    , map AuthRoute top
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute

roomPath : String
roomPath = "/rooms"

