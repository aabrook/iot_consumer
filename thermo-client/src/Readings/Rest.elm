module Readings.Rest exposing
  ( listGraphqlRooms
  )

import Readings.Types exposing (..)
import Http exposing (header)

import Monad.Reader as Reader exposing (Reader(..))

import GraphQL.Client.Http exposing (customSendQuery)
import GraphQL.Request.Builder exposing (..)

import Task exposing (attempt)
import Maybe exposing (Maybe)

roomsQuery : Document Query (List Room) a
roomsQuery =
  let
    room = object Room
      |> with (field "room" [] string)
      |> with (field "temperature" [] int)
      |> with (field "humidity" [] int)
      |> with (field "updated_at" [] string)
      |> with (field "status" [] (nullable status))

    status = object Status
        |> with (field "status" [] string)
        |> with (field "updated_at" [] string)

    queryRoot = extract
      (field "temperatures" [] (list room))
  in
     queryDocument queryRoot

roomsRequest : Request Query (List Room)
roomsRequest = roomsQuery |> GraphQL.Request.Builder.request {}

listGraphqlRooms : Reader ApiRequest (Cmd Msg)
listGraphqlRooms =
  Reader (\{ config, authorization } ->
    let
        url = config.apiUrl ++ "/api"
        customRequest =
          { method = "POST"
          , headers = [header "Authorization" authorization]
          , url = url
          , timeout = Nothing
          , withCredentials = False
          }
    in
       customSendQuery customRequest roomsRequest |> attempt GqlRoomListFound
     )
