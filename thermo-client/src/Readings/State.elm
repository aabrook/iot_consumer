module Readings.State exposing (..)

import Readings.Types exposing (Model, Msg(..), model)
import Readings.Rest exposing (..)
import Http exposing (Header)

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

update : Msg -> Model -> List Header -> ( Model, Cmd Msg )
update msg model headers =
  let
    queryRooms = listRooms headers
  in
    case msg of
      ListRooms -> ( model, queryRooms )
      RoomListFound (Ok rooms) -> ( { model | roomList = rooms, error = Nothing }, Cmd.none )
      RoomListFound (Err _) -> ( { model | error = Just "Error listing rooms" }, Cmd.none )

transition : List Header -> Cmd Msg
transition = listRooms
