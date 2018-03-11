module App.Events where

import Prelude (discard)
import Control.Applicative (pure)
import Control.Bind ((=<<), bind)
import Control.Monad.Eff.Class (liftEff)
import App.Routes (Route, match)
import App.State (State(..))
import Data.Function (($))
import Data.Maybe
import Network.HTTP.Affjax (AJAX)
import Pux (EffModel, noEffects)
import Pux.DOM.Events (DOMEvent)
import DOM.Event.Event (preventDefault)
import DOM.HTML.History (DocumentTitle(..), URL(..), pushState)
import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Types (HISTORY)
import DOM.HTML.Window (history)
import Data.Foreign (toForeign)

data Event = PageView Route | Navigate String DOMEvent

type AppEffects fx = (ajax :: AJAX, history :: HISTORY, dom :: DOM | fx)

foldp :: ∀ fx. Event -> State -> EffModel State Event (AppEffects fx)
foldp (PageView route) (State st) = noEffects $ State st { route = route, loaded = true }
foldp (Navigate url ev) st = { state: st
  , effects: [
      liftEff do
        preventDefault ev
        h <- history =<< window
        pushState (toForeign {}) (DocumentTitle "") (URL url) h
        pure $ Just $ PageView (match url)
  ]}
