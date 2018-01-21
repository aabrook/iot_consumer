module Main exposing (..)

import Html exposing (Html, button, text, div, h1, img, input, select, option)
import Html.Events exposing (onInput, onClick, on)
import Http exposing (..)
import Json.Decode as Decode


---- MODEL ----


type alias Model =
  {
    bearer : String
    , room : String
    , roomResult : String
    , roomList : List String
  }

defaultModel : Model
defaultModel =
  {
    bearer = ""
    , room = ""
    , roomResult = ""
    , roomList = []
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
    | ListRooms
    | RoomFound (Result Http.Error String)
    | RoomListFound (Result Http.Error (List String))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )
    UpdateBearer token -> ( { model | bearer = token }, Cmd.none )
    UpdateRoom room -> ( { model | room = room }, Cmd.none )
    QueryRoom -> ( model, queryApi model.room model.bearer )
    ListRooms -> ( model, listRooms model.bearer )
    RoomFound (Ok room) -> ( { model | roomResult = room }, Cmd.none )
    RoomFound (Err _) -> ( { model | roomResult = "Room not found" }, Cmd.none )
    RoomListFound (Ok rooms) -> ( { model | roomList = rooms }, Cmd.none )
    RoomListFound (Err _) -> ( { model | roomResult = "Error listing rooms" }, Cmd.none )


---- VIEW ----


view : Model -> Html Msg
view model =
  div []
    [ div []
      [ text "What is your bearer token?"
      , input [ onInput UpdateBearer ] []
      ]
    , button [ onClick ListRooms ] [ text "List Rooms" ]
    , div []
      [ text "Which room?"
      , select [ onInput UpdateRoom ] <| List.map (\r -> option [] [ text r ])  <| "" :: model.roomList
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
      "/temperatures/latest?room=" ++ room
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

listRooms : String -> Cmd Msg
listRooms token =
  let
    url =
      "/temperatures/rooms"
    get =
      request
      { method = "GET"
      , headers = headers token
      , url = url
      , body = emptyBody
      , expect = expectJson (Decode.list Decode.string)
      , timeout = Nothing
      , withCredentials = False
    }
  in
    Http.send RoomListFound get

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
