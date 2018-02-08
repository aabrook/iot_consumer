module LensTest exposing (..)

import Test exposing (..)
import Expect
import Lens.Lens as Lens
import Array

-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!

doubleMaybe : Maybe Int -> Int
doubleMaybe m =
  case m of
    Just n -> n * 2
    Nothing -> 0

record : { a: String, b: { c: String } }
record = { a = "a", b = { c = "c" } }

view : Test
view =
  describe "Lens viewing"
    [ test "Array lens view when found" <|
      \_ ->
        Expect.equal (Lens.view (Lens.arrayLens 2) (Array.fromList [1,2,3])) (Just 3)
    , test "Array lens view nothing found" <|
      \_ ->
        Expect.equal (Lens.view (Lens.arrayLens 5) (Array.fromList [1,2,3])) (Nothing)
    , test "Record lens view" <|
      \_ ->
        Expect.equal (Lens.view (Lens.recordLens .a (\s v -> { s | a = v })) record) "a"
    ]

set : Test
set =
  describe "Lens setting"
    [ test "Array lens set value" <|
      \_ ->
        Expect.equal (Lens.set (Lens.arrayLens 2) 5 (Array.fromList [1, 2, 3])) (Array.fromList [1, 2, 5])
    , test "Array lens set out of range" <|
      \_ ->
        Expect.equal (Lens.set (Lens.arrayLens 5) 5 (Array.fromList [1, 2, 3])) (Array.fromList [1, 2, 3])
    , test "Record lens set" <|
      \_ ->
        Expect.equal (Lens.set (Lens.recordLens .a (\s v -> { s | a = v })) 5 record) ({ record | a = 5 })
    ]

over : Test
over =
  describe "Lens over"
    [ test "Array lens provide value to function" <|
      \_ ->
        Expect.equal (Lens.over (Lens.arrayLens 2) doubleMaybe (Array.fromList [1, 2, 3])) (Array.fromList [1, 2, 6])
    , test "Array lens doesn't do change if out of index" <|
      \_ ->
        Expect.equal (Lens.over (Lens.arrayLens 5) doubleMaybe (Array.fromList [1, 2, 3])) (Array.fromList [1, 2, 3])
    , test "Record lens over" <|
      \_ ->
        Expect.equal (Lens.over (Lens.recordLens .a (\s v -> { s | a = v })) (String.toUpper) record) ({ record | a = "A" })
    ]
