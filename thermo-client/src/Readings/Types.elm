module Readings.Types exposing (Model, model, Room, Msg(..))
import Http exposing (Error)

type alias Model =
  { room : String
    , roomResult : Maybe Room
    , roomList : List String
    , error : Maybe String
  }

model : Model
model =
  { room = ""
    , roomResult = Nothing
    , roomList = []
    , error = Nothing
  }

type alias Room =
  { room : String
  , temperature : String
  }

type Msg
    = UpdateRoom String
    | QueryRoom
    | ListRooms
    | RoomFound (Result Http.Error Room)
    | RoomListFound (Result Http.Error (List String))
