module Monad.Reader exposing (..)

type Reader env b = Reader (env -> b)

runReader : Reader env b -> env -> b
runReader (Reader f) env = f env

reader : b -> Reader env b
reader = Reader << always

map : (a -> b) -> Reader env a -> Reader env b
map f (Reader r) = Reader (f << r)

andThen : (a -> Reader env b) -> Reader env a -> Reader env b
andThen f (Reader r) =
  Reader (\env -> runReader (r env |> f) env)

ask : Reader env env
ask = Reader identity
