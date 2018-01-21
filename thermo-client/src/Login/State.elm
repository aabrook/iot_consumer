module Login.State exposing (init, update, withAuth)

import Login.Types exposing (..)
import Http exposing (Header, header)
import Navigation exposing (newUrl)
import Routing exposing (roomPath)

init : ( Model, Cmd Msg )
init = ( model, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateBearer token -> ( { model | bearer = token }, Cmd.none )
    Login -> ( model, newUrl roomPath )

withAuth : Model -> (List Header -> (a, b)) -> (a, b)
withAuth { bearer } fn
  = bearer
    |> bearerHeader
    |> fn

bearerHeader : String -> List Header
bearerHeader token =
  [ header "Authorization" <| "Bearer " ++ token
  ]