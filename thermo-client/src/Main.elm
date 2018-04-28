module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Readings.State as RS exposing (init, update)
import Readings.Types as RT exposing (..)
import Readings.View as RV exposing (view)

import Monad.Reader exposing (runReader)

import Login.State as LS exposing (init, update, withAuth)
import Login.Types as LT exposing (..)
import Login.View as LV exposing (view)

import Config exposing (Config)

import Routing exposing (..)
import Navigation exposing (Location, programWithFlags)

---- MODEL ----


type alias Model =
  { auth : LT.Model
    , room : RT.Model
    , route : Route
    , error : Maybe String
    , apiUrl : String
  }


init : Config -> Location -> ( Model, Cmd Msg )
init { apiUrl } location =
  let
    ( roomModel, roomMsg ) =
      RS.init
    ( loginModel, loginMsg ) =
      LS.init
    initRoute =
      case parseLocation location of
        AuthRoute -> AuthRoute
        NotFoundRoute -> AuthRoute
        RoomRoute ->
          if LS.isAuthed loginModel then
             RoomRoute
          else
            AuthRoute

  in
    ( { auth = loginModel
      , room = roomModel
      , route = initRoute
      , error = Nothing
      , apiUrl = apiUrl
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
        (roomModel, cmd) = runReader (RS.update roomMsg model.room) { apiUrl = model.apiUrl, authorization = "bearer " ++ (Maybe.withDefault "" model.auth.bearer) }
        roomCmd = Cmd.map UpdateRoom cmd
      in
        ({ model | room = roomModel }, roomCmd )
    OnLocationChange location ->
      let
        newRoute = parseLocation location
        cmd = runReader (RS.transition) { apiUrl = model.apiUrl, authorization = "bearer " ++ (Maybe.withDefault "" model.auth.bearer) }
        roomCmd = Cmd.map UpdateRoom cmd
      in
        ( { model | route = newRoute }, roomCmd )


---- VIEW ----


view : Model -> Html Msg
view model =
  let
    roomView = Html.map UpdateRoom <| RV.view model.room
    loginView = Html.map UpdateLogin <| LV.view model.auth
    view =
      case model.route of
        AuthRoute -> loginView
        RoomRoute ->
          if LS.isAuthed model.auth then
            roomView
          else
            loginView
        NotFoundRoute -> text "Page not found"
    errorView =
      case model.error of
        Nothing -> div [ style [("display", "none")] ] []
        Just message -> div [ style [("display", "block")] ] [ text message ]
  in
    div []
      [ errorView
      , div []
        [ view
        ]
    ]


---- PROGRAM ----


main : Program Config Model Msg
main =
  Navigation.programWithFlags OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
