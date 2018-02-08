module Lens.Lens exposing
  ( view
  , set
  , over
  , arrayLens
  , recordLens
  , compose
  )

import Array

type Getter s a = Getter (s -> a)
type Setter s b t = Setter (s -> b -> t)

type alias Lens s t a b = (Getter s a, Setter s b t)

view : Lens s t a b -> s -> a
view (getter, setter) s =
  case getter of
    Getter f -> f s

over : Lens s t a b -> (a -> b) -> s -> t
over (getter, setter) f state =
  case getter of
    Getter g -> case setter of
                  Setter s -> g state |> f |> s state

set : Lens s t a b -> b -> s -> t
set lens v = over lens (always v)

arrayLens : Int -> (Getter (Array.Array a) (Maybe a), Setter (Array.Array a) a (Array.Array a))
arrayLens index =
  let
    getter = Array.get index
    setter v xs = Array.set index xs v
  in
    (Getter getter, Setter setter)

recordLens : (s -> a) -> (s -> b -> t) -> Lens s t a b
recordLens g s =
  (Getter g, Setter s)

compose (lg, ls) (rg, rs) =
  let
    rightSetter = case rs of
      Setter f -> f
    leftSetter = case ls of
      Setter f -> f
    setter = case lg of
      Getter g -> \obj val -> leftSetter obj <| rightSetter (leftGetter obj) val

    leftGetter = case lg of
      Getter f -> f
    rightGetter = case rg of
      Getter f -> f
    getter = leftGetter >> rightGetter
  in
    (Getter getter, Setter setter)

