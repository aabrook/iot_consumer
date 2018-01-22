module Readings.Types exposing (Model, model, Room, Msg(..))
import Http exposing (Error)

type alias Model =
  { room : String
    , roomResult : Room
    , roomList : List String
    , error : String
  }

model : Model
model =
  { room = ""
    , roomResult = room
    , roomList = []
    , error = ""
  }

type alias Room =
  { room : String
  , temperature : String
  }

room : Room
room =
  { temperature = ""
  , room = ""
  }

type Msg
    = UpdateRoom String
    | QueryRoom
    | ListRooms
    | RoomFound (Result Http.Error Room)
    | RoomListFound (Result Http.Error (List String))
