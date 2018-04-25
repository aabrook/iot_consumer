module Readings.State exposing (..)

import Readings.Types exposing (Model, Msg(..), model)
import Readings.Rest exposing (..)
import Http exposing (Header, Error(..))

init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )

errorToString : Error -> String
errorToString err =
  case err of
    Timeout -> "Timeout"
    NetworkError -> "Network Error"
    BadStatus code -> "Bad Status " ++ (toString code)
    BadUrl url -> "Bad URL " ++ url
    BadPayload msg _ -> "Bad Payload " ++ msg
    -- UnexpectedPayload msg -> "Unexpected Payload " ++ msg
    -- BadResponse code msg -> "Bad Response " ++ (toString code) ++ " " ++ msg

update : Msg -> Model -> List Header -> ( Model, Cmd Msg )
update msg model headers =
  let
    queryRooms = listRooms headers
  in
    case msg of
      ListRooms -> ( model, queryRooms )
      RoomListFound (Ok rooms) -> ( { model | roomList = rooms, error = Nothing }, Cmd.none )
      RoomListFound (Err err) -> ( { model | error = err |> errorToString |> Just }, Cmd.none )

transition : List Header -> Cmd Msg
transition = listRooms
