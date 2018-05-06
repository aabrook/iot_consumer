module Readings.Rest exposing
  ( listRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

import Monad.Reader as Reader exposing (Reader(..), reader, ask)


decodeTemperature : Decode.Decoder Int
decodeTemperature =
  Decode.at ["temperature"] Decode.int

decodeName : Decode.Decoder String
decodeName =
  Decode.at ["room"] Decode.string

decodeDate : Decode.Decoder String
decodeDate =
  Decode.at ["updated_at"] Decode.string

decodeRoom : Decode.Decoder Room
decodeRoom =
  Decode.map3
  Room
  decodeName
  decodeTemperature
  decodeDate

listRooms : Reader ApiRequest (Cmd Msg) -- String -> List Header -> Cmd Msg
listRooms =
  Reader (\{ config, authorization } ->
    let
        url =
          config.apiUrl ++ "/temperatures"
        get =
          request
          { method = "GET"
          , headers = [header "Authorization" authorization]
          , url = url
          , body = emptyBody
          , expect = expectJson (Decode.list decodeRoom)
          , timeout = Nothing
          , withCredentials = False
          }
    in
       Http.send RoomListFound get
  )

