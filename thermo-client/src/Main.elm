module Main exposing (..)

import Html exposing (Html, button, text, div, h1, img, input)
import Html.Attributes exposing (src)
import Html.Events exposing (onInput, onClick)
import Http exposing (..)
import Json.Decode as Decode


---- MODEL ----


type alias Model =
  {
    bearer : String
    , room : String
    , roomResult : String
  }

defaultModel : Model
defaultModel =
  {
    bearer = ""
    , room = ""
    , roomResult = ""
  }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | UpdateBearer String
    | UpdateRoom String
    | QueryRoom
    | RoomFound (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )
    UpdateBearer token -> ( { model | bearer = token }, Cmd.none )
    UpdateRoom room -> ( { model | room = room }, Cmd.none )
    QueryRoom -> ( model, queryApi model.room model.bearer )
    RoomFound (Ok room) -> ( { model | roomResult = room }, Cmd.none )
    RoomFound (Err _) -> ( { model | roomResult = "Room not found" }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
  div []
    [ div []
      [ text "What is your bearer token?"
      , input [ onInput UpdateBearer ] []
      ]
    , div []
      [ text "Which room?"
      , input [ onInput UpdateRoom ] []
      ]
    , button [ onClick QueryRoom ] [ text "Query Room" ]
    , div []
      [ text model.roomResult
      ]
    ]

---- REST ----

decodeRoom : Decode.Decoder String
decodeRoom =
  Decode.at ["data", "t"] Decode.string

queryApi : String -> String -> Cmd Msg
queryApi room token =
  let
    url =
      "http://localhost:8080/temperatures/latest?room=" ++ room
    get =
      request
      { method = "GET"
      , headers = headers token
      , url = url
      , body = emptyBody
      , expect = expectJson decodeRoom
      , timeout = Nothing
      , withCredentials = False
    }
  in
    Http.send RoomFound get


headers : String -> List Header
headers token = [
   header "Authorization" <| "Bearer " ++ token
   , header "Access-Control-Request-Method" "GET,OPTIONS"
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
