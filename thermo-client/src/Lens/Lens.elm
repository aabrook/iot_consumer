module Lens.Lens exposing
  ( view
  , set
  , over
  , arrayLens
  , recordLens
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

