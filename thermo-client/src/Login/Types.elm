module Login.Types exposing (..)

type alias Model =
  { bearer : Maybe String
  , bearerError : Maybe String
  }

model : Model
model =
  { bearer = Nothing
  , bearerError = Nothing
  }

type Msg
  = UpdateBearer String
  | Login
