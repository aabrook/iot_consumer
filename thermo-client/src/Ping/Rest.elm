module Ping.Rest exposing
  ( listGraphqlPings
  )

import Ping.Types exposing (..)
import Readings.Types exposing (ApiRequest)
import Http exposing (header)

import Monad.Reader as Reader exposing (Reader(..))

import GraphQL.Client.Http exposing (customSendQuery)
import GraphQL.Request.Builder exposing (..)

import Task exposing (attempt)
import Maybe exposing (Maybe)

pingsQuery : Document Query (List Ping) a
pingsQuery =
  let
    ping = object Ping
      |> with (field "id" [] string)
      |> with (field "time" [] string)
      |> with (field "ttl" [] string)
      |> with (field "source" [] string)
      |> with (field "destination" [] string)
      |> with (field "insertedAt" [] string)

    queryRoot = extract
      (field "pings" [] (list ping))
  in
     queryDocument queryRoot

pingRequest : Request Query (List Ping)
pingRequest = pingsQuery |> GraphQL.Request.Builder.request {}

listGraphqlPings : Reader ApiRequest (Cmd Msg)
listGraphqlPings =
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
       customSendQuery customRequest pingRequest |> attempt GqlPingListFound
     )

