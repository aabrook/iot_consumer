module Login.Types exposing (..)

type alias Model = {
  bearer : String
  }

model : Model
model =
  { bearer = ""
  }

type Msg
  = UpdateBearer String
