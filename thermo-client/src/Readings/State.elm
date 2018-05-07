module Readings.State exposing (..)

import Readings.Types exposing (ApiRequest, Model, Msg(..), model)
import Readings.Rest exposing (..)
import Http exposing (Header, Error(..))

import Monad.Reader as Reader exposing (Reader(..), andThen, ask, reader, runReader)

import GraphQL.Client.Http as Gql exposing (Error(..))

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

errorToString : Http.Error -> String
errorToString err =
  case err of
    Timeout -> "Timeout"
    NetworkError -> "Network Error"
    BadStatus stat -> stat |> .status |> .message
    BadUrl url -> "Bad URL " ++ url
    BadPayload msg _ -> "Bad Payload " ++ msg

update : Msg -> Model -> Reader ApiRequest ( Model, Cmd Msg )
update msg model =
  let
    queryRooms = Reader.ask |> Reader.andThen (\env -> runReader listGraphqlRooms env |> reader)
  in
    case msg of
      ListRooms -> Reader (\env -> ( model, runReader queryRooms env ))
      RoomListFound (Ok rooms) -> reader ( { model | roomList = rooms, error = Nothing }, Cmd.none )
      RoomListFound (Err err) -> reader ( { model | error = err |> errorToString |> Just }, Cmd.none )
      GqlRoomListFound (Ok rooms) -> reader ( { model | roomList = rooms, error = Nothing }, Cmd.none )
      GqlRoomListFound (Err (Gql.GraphQLError errs)) -> reader ({ model | error = Just "GraphQL request Failed" }, Cmd.none)
      GqlRoomListFound (Err (Gql.HttpError err)) -> reader ({ model | error = err |> errorToString |> Just }, Cmd.none)

transition : Reader ApiRequest (Cmd Msg)
transition = listGraphqlRooms
