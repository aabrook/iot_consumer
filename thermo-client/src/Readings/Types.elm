module Readings.Types exposing (..)
import Http exposing (Error)

type alias Model =
  { room : String
    , roomResult : String
    , roomList : List String
  }

model : Model
model =
  { room = ""
    , roomResult = ""
    , roomList = []
  }

type Msg
    = UpdateRoom String
    | QueryRoom
    | ListRooms
    | RoomFound (Result Http.Error String)
    | RoomListFound (Result Http.Error (List String))
