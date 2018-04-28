module ReaderTest exposing (..)

import Test exposing (..)
import Expect

import Monad.Reader exposing (..)

view : Test
view =
  describe "Reader Monad"
    [ test "Can run a reader" <|
      \_ ->
        let
          result = runReader (reader 5) ""
          expected = 5
        in
          Expect.equal result expected
    , test "Will map the function over the value" <|
      \_ ->
        let
          expected = 10
          result = runReader (reader 5 |> map (\a -> a * 2)) ""
        in
           Expect.equal result expected
    , test "Will bind the function over the value and return a reader" <|
      \_ ->
        let
          expected = 10
          result = runReader (reader 5 |> andThen (\a -> reader <| a * 2)) ""
        in
           Expect.equal result expected
    , test "Will grab the environment" <|
      \_ ->
        let
          expected = 10
          result = runReader (reader 5 |> andThen (\v -> ask |> map (\env -> env * v))) 2
        in
          Expect.equal result expected
    ]
