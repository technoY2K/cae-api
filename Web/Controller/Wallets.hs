module Web.Controller.Wallets where

import           Blockfrost.Client
import           Web.Controller.Prelude

instance Controller WalletsController where
    action ShowWalletAction = renderPlain "Test"
