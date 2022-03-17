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
import           Web.View.Dashboard.Index (IndexView (IndexView))

instance Controller DashboardController where
    action DashboardAction = do
        case currentUserOrNothing of
            Just currentUser -> renderPlain $ convert (get #email currentUser)

            Nothing          -> renderPlain "Go login first"

        render IndexView

convert :: Text -> BL.ByteString
convert = BL.fromChunks . return . encodeUtf8
