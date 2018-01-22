module Readings.Rest exposing
  ( roomDetails
  , listRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

decodeTemperature : Decode.Decoder String
decodeTemperature =
  Decode.at ["data", "t"] Decode.string

decodeName : Decode.Decoder String
decodeName =
  Decode.at ["data", "r"] Decode.string

decodeRoom : Decode.Decoder Room
decodeRoom =
  Decode.map2
  Room
  decodeName
  decodeTemperature

roomDetails : List Header -> String -> Cmd Msg
roomDetails headers room =
  let
    url =
      "/temperatures/latest?room=" ++ room
    get =
      request
      { method = "GET"
      , headers = headers
      , url = url
      , body = emptyBody
      , expect = expectJson decodeRoom
      , timeout = Nothing
      , withCredentials = False
    }
  in
    Http.send RoomFound get

listRooms : List Header -> Cmd Msg
listRooms headers =
  let
    url =
      "/temperatures"
    get =
      request
      { method = "GET"
      , headers = headers
      , url = url
      , body = emptyBody
      , expect = expectJson (Decode.list decodeRoom)
      , timeout = Nothing
      , withCredentials = False
    }
  in
    Http.send RoomListFound get

