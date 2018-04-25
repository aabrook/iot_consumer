module Readings.Rest exposing
  ( listRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

decodeTemperature : Decode.Decoder String
decodeTemperature =
  Decode.at ["data", "temperature"] Decode.string

decodeName : Decode.Decoder String
decodeName =
  Decode.at ["data", "room"] Decode.string

decodeDate : Decode.Decoder String
decodeDate =
  Decode.at ["created_at"] Decode.string

decodeRoom : Decode.Decoder Room
decodeRoom =
  Decode.map3
  Room
  decodeName
  decodeTemperature
  decodeDate

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

