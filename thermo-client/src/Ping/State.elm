module Ping.State exposing (..)

import Ping.Types exposing (..)
import Ping.Rest exposing (..)
import Readings.Types exposing (ApiRequest)

import Monad.Reader as Reader exposing (Reader(..), andThen, ask, reader, runReader)
import GraphQL.Client.Http as Gql exposing (Error(..))

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

update : Msg -> Model -> Reader ApiRequest ( Model, Cmd Msg )
update msg model =
  let
    queryPings = Reader.ask |> Reader.andThen (\env -> runReader listGraphqlPings env |> reader)
  in
    case msg of
      ListPings -> Reader (\env -> ( model, runReader queryPings env ))
      GqlPingListFound (Ok pings) -> reader ( { model | pings = pings, error = Nothing }, Cmd.none )
      GqlPingListFound (Err (Gql.GraphQLError errs)) -> reader ({ model | error = Just "GraphQL request Failed" }, Cmd.none)
      GqlPingListFound (Err (Gql.HttpError err)) -> reader ({ model | error = Just "HTTP request failed" }, Cmd.none)

