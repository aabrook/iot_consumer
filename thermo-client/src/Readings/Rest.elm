module Readings.Rest exposing
  ( listRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

import Monad.Reader as Reader exposing (Reader(..), reader, ask)


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

listRooms : Reader ApiRequest (Cmd Msg) -- String -> List Header -> Cmd Msg
listRooms =
  Reader (\{ apiUrl, authorization } ->
    let
        url =
          apiUrl ++ "/temperatures"
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

