module Readings.Types exposing (ApiRequest, Model, model, Room, Msg(..))
import Http exposing (Error)

type alias Model =
  { roomList : List Room
  , error : Maybe String
  }

type alias ApiRequest = {
  apiUrl : String
  , authorization : String
  }

model : Model
model =
  { roomList = []
  , error = Nothing
  }

type alias Room =
  { room : String
  , temperature : String
  , date : String
  }

type Msg
    = ListRooms
    | RoomListFound (Result Http.Error (List Room))
