module Ping.Types exposing (..)

import GraphQL.Client.Http

model : Model
model = { pings = [], error = Nothing }

type alias Model = {
  pings : List Ping
  , error : Maybe String
  }

type alias Ping = {
  id : String
  , time : String
  , ttl : String
  , source : String
  , destination : String
  , insertedAt : String
  , updatedAt : String
  }

type Msg = ListPings
    | GqlPingListFound (Result GraphQL.Client.Http.Error (List Ping))
