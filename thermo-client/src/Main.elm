module Main exposing (..)

import Html exposing (Html, button, text, div, h1, img, input, select, option)
import Html.Events exposing (onInput, onClick, on)

import Readings.State as RS exposing (..)
import Readings.Types as RT exposing (..)
import Readings.View as RV exposing (view)
import Helpers exposing (WithBearer(..))

---- MODEL ----


type alias Model =
  {
    bearer : String
    , room : RT.Model
  }

defaultModel : RT.Model -> Model
defaultModel room =
  {
    bearer = ""
    , room = room
  }


init : ( Model, Cmd Msg )
init =
  let
    ( roomModel, roomMsg ) =
      RS.init
  in
    ( defaultModel roomModel, Cmd.none )



---- UPDATE ----


type Msg
    = UpdateBearer String
    | UpdateRoom RT.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateBearer token -> ( { model | bearer = token }, Cmd.none )
    UpdateRoom roomMsg ->
      let
        ( room, cmd ) = RS.update roomMsg <| WithBearer model.bearer model.room
        roomCmd = Cmd.map UpdateRoom cmd
      in
        ( { model | room = room }, roomCmd )


---- VIEW ----


view : Model -> Html Msg
view model =
  let
    roomView = Html.map UpdateRoom <| RV.view model.room
  in
    div []
      [ div []
        [ text "What is your bearer token?"
        , input [ onInput UpdateBearer ] []
        , roomView
        ]
      ]


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
