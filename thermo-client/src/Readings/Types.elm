module Readings.Types exposing (Model, model, Room, Msg(..))
import Http exposing (Error)

type alias Model =
  { roomList : List Room
  , error : Maybe String
  }

model : Model
model =
  { roomList = []
  , error = Nothing
  }

type alias Room =
  { room : String
  , temperature : String
  }

type Msg
    = ListRooms
    | RoomListFound (Result Http.Error (List Room))
