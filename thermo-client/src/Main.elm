module Main exposing (..)

import Html exposing (Html, div, text)

import Readings.State as RS exposing (init, update)
import Readings.Types as RT exposing (..)
import Readings.View as RV exposing (view)

import Login.State as LS exposing (init, update, withAuth)
import Login.Types as LT exposing (..)
import Login.View as LV exposing (view)

import Routing exposing (..)
import Navigation exposing (Location, program)

---- MODEL ----


type alias Model =
  {
    auth : LT.Model
    , room : RT.Model
    , route : Route
  }


init : Location -> ( Model, Cmd Msg )
init location =
  let
    ( roomModel, roomMsg ) =
      RS.init
    ( loginModel, loginMsg ) =
      LS.init
    initRoute = parseLocation location
  in
    ( { auth = loginModel
      , room = roomModel
      , route = initRoute
      }, Cmd.none )



---- UPDATE ----


type Msg
    = UpdateLogin LT.Msg
    | UpdateRoom RT.Msg
    | OnLocationChange Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateLogin loginMsg ->
      let
        ( login, cmd ) = LS.update loginMsg model.auth
        loginCmd = Cmd.map UpdateLogin cmd
      in
        ( { model | auth = login }, loginCmd )
    UpdateRoom roomMsg ->
      let
        ( room, cmd ) = withAuth model.auth <|  RS.update roomMsg model.room
        roomCmd = Cmd.map UpdateRoom cmd
      in
        ( { model | room = room }, roomCmd )
    OnLocationChange location ->
      let
        newRoute = parseLocation location
      in
        ( { model | route = newRoute }, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view model =
  let
    roomView = Html.map UpdateRoom <| RV.view model.room
    loginView = Html.map UpdateLogin <| LV.view model.auth
    view =
      case model.route of
        AuthRoute -> loginView
        RoomRoute -> roomView
        NotFoundRoute -> text "Page not found"
  in
    div []
      [ view
      ]


---- PROGRAM ----


main : Program Never Model Msg
main =
  Navigation.program OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
