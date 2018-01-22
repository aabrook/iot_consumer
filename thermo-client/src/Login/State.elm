module Login.State exposing (init, update, withAuth, isAuthed)

import Login.Types exposing (..)
import Http exposing (Header, header)
import Navigation exposing (newUrl)
import Routing exposing (roomPath)

init : ( Model, Cmd Msg )
init = ( model, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateBearer token -> ( { model | bearer = Just <| String.trim token, bearerError = Nothing }, Cmd.none )
    Login ->
      let
        (newModel, newCmd) =
          case model.bearer of
            Nothing -> ( { model | bearerError = Just "No bearer provided" }, Cmd.none )
            Just string ->
              case String.trim string of
                "" -> ( { model | bearerError = Just "No bearer provided" }, Cmd.none )
                bearer -> ( { model | bearerError = Nothing, bearer = Just bearer }, newUrl roomPath )
      in
        ( newModel, newCmd )

withAuth : Model -> (List Header -> (a, b)) -> Result String (a, b)
withAuth { bearer } fn =
  case bearer of
    Nothing -> Err "A bearer has not been provided"
    Just b -> b |> bearerHeader |> fn |> Ok

isAuthed : Model -> Bool
isAuthed { bearer } = bearer /= Nothing

bearerHeader : String -> List Header
bearerHeader token =
  [ header "Authorization" <| "Bearer " ++ token
  ]
