module Readings.Types exposing (ApiRequest, Model, model, Room, Status, Msg(..))
import Config exposing (Config)
import GraphQL.Client.Http

type alias Model =
  { roomList : List Room
  , error : Maybe String
  }

type alias ApiRequest = {
  config : Config
  , authorization : String
  }

model : Model
model =
  { roomList = []
  , error = Nothing
  }

type alias Room =
  { room : String
  , temperature : Int
  , humidity : Int
  , date : String
  , status : Maybe Status
  }

type alias Status =
  { status : String
  , date : String
  }

type Msg
    = ListRooms
    | GqlRoomListFound (Result GraphQL.Client.Http.Error (List Room))
