module Web.Controller.Dashboard where

import           BasicPrelude             (Maybe (Just, Nothing),
                                           Monad (return), Text, encodeUtf8,
                                           ($), (.))
import qualified Data.ByteString.Lazy     as BL
import           Web.Controller.Prelude   (Controller (action),
                                           DashboardController (..),
                                           Maybe (Just, Nothing),
                                           Monad (return), User' (email),
                                           currentUserOrNothing, get, render,
                                           renderPlain, ($), (.))
import           Web.View.Dashboard.Index (IndexView (IndexView, userEmail))

instance Controller DashboardController where
    action DashboardAction =
        let userEmail = case currentUserOrNothing of
                Just currentUser -> Just (get #email currentUser)
                Nothing          -> Nothing

        in render IndexView { userEmail }
