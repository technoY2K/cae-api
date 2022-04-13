module Web.Controller.Wallets where

import qualified Data.ByteString.Lazy   as BL
import qualified Data.Text              as T
import qualified Data.Text.Encoding     as T
import           Debug.Trace
import qualified Web.Common.CardanoAPI  as C
import           Web.Controller.Prelude

instance Controller WalletsController where
    action ShowWalletAddressesAction = do
        let s = param @Text "stakeid"
        result <- C.getAllAddressesByStake s

        renderJson result

    action ShowWalletAssets = do
        let s = param @Text "stakeid"
        result <- C.getAssetsAssociatedByAddress s

        renderJson result

