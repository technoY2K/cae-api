module Web.Controller.Wallets where

import           Blockfrost.Client
import           Data.ByteString.Lazy   as BL
import           Data.Text              as T
import           Data.Text.Encoding     as T
import           Debug.Trace
import           Web.Controller.Prelude

instance Controller WalletsController where
    action ShowWalletAction = do
        project <- projectFromFile ".blockfrost"
        result <- runBlockfrost project $ do
                let si = param @Text "stakeid"
                getAccount (Address si)

        case result of
            Left e -> renderPlain $ BL.fromChunks . return . T.encodeUtf8 $ (parseBFError e)
            Right a -> do
                let isActive = _accountInfoActive a
                trace (T.unpack $ show isActive) renderPlain "test"

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"

