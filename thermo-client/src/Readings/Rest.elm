module Readings.Rest exposing
  ( listRooms
  , listGraphqlRooms
  )

import Readings.Types exposing (..)
import Http exposing (Header, emptyBody, expectJson, header, request)
import Json.Decode as Decode

import Monad.Reader as Reader exposing (Reader(..), reader, ask)

import GraphQL.Client.Http exposing (sendQuery)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var

import Task exposing (attempt)

roomsQuery : Document Query (List Room) a
roomsQuery =
  let
    room = object Room
      |> with (field "room" [] string)
      |> with (field "temperature" [] int)
      |> with (field "updated_at" [] string)
    queryRoot = extract
      (field "temperatures" [] (list room))
  in
     queryDocument queryRoot

roomsRequest : Request Query (List Room)
roomsRequest = roomsQuery |> GraphQL.Request.Builder.request {}

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

listGraphqlRooms =
  Reader (\{ config } ->
    let
        url = config.apiUrl ++ "/api"
    in
       sendQuery url roomsRequest |> attempt GqlRoomListFound
     )

listRooms : Reader ApiRequest (Cmd Msg) -- String -> List Header -> Cmd Msg
listRooms =
  Reader (\{ config, authorization } ->
    let
        url =
          config.apiUrl ++ "/temperatures"
        get =
          Http.request
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
