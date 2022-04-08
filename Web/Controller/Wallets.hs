module Web.Controller.Wallets where

import           Blockfrost.Client
import           Data.Text
import           Debug.Trace
import           Web.Controller.Prelude

instance Controller WalletsController where
    action ShowWalletAction = do
        let si = param @Text "stakeid"
        trace (unpack si) (renderPlain "test")
