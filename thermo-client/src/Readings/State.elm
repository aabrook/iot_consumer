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
    queryRoom = roomDetails headers
    queryRooms = listRooms headers
  in
    case msg of
      UpdateRoom room -> ( { model | room = room }, Cmd.none )
      QueryRoom -> ( model, queryRoom model.room  )
      ListRooms -> ( model, queryRooms)
      RoomFound (Ok room) -> ( { model | roomResult = room }, Cmd.none )
      RoomFound (Err _) -> ( { model | roomResult = "Room not found" }, Cmd.none )
      RoomListFound (Ok rooms) -> ( { model | roomList = rooms }, Cmd.none )
      RoomListFound (Err _) -> ( { model | roomResult = "Error listing rooms" }, Cmd.none )

