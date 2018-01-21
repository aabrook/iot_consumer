module Helpers exposing (..)

import Http exposing (Header, header)

type WithBearer m = WithBearer String m

bearerHeader : String -> List Header
bearerHeader token =
  [ header "Authorization" <| "Bearer " ++ token
  ]

