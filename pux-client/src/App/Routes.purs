module App.Routes where

import Prelude ((<$>))
import Data.Function (($))
import Data.Functor ((<$))
import Control.Apply ((<*))
import Control.Alt ((<|>))
import Data.Maybe (fromMaybe)
import Pux.Router (lit, end, router)

data Route = Temps | Home | NotFound String

match :: String -> Route
match url = fromMaybe (NotFound url) $ router url $
  Home <$ end
  <|>
  Temps <$ (lit "temps") <* end

toURL :: Route -> String
toURL (NotFound url) = url
toURL (Home) = "/"
toURL (Temps) = "/temps"
