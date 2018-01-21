module Readings.Rest exposing
  ( roomDetails
  , listRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

decodeRoom : Decode.Decoder String
decodeRoom =
  Decode.at ["data", "t"] Decode.string

roomDetails : List Header -> String -> Cmd Msg
roomDetails headers room =
  let
    url =
      "/temperatures/latest?room=" ++ room
    get =
      request
      { method = "GET"
      , headers = headers ++ corsHeader
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
      "/temperatures/rooms"
    get =
      request
      { method = "GET"
      , headers = headers ++ corsHeader
      , url = url
      , body = emptyBody
      , expect = expectJson (Decode.list Decode.string)
      , timeout = Nothing
      , withCredentials = False
    }
  in
    Http.send RoomListFound get


corsHeader : List Header
corsHeader = [
   header "Access-Control-Request-Method" "GET,OPTIONS"
  ]

