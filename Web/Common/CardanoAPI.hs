module Web.Common.CardanoAPI where

import           Blockfrost.Client
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           Debug.Trace
import           IHP.Prelude

getProject :: IO Project
getProject = projectFromFile ".blockfrost"

getAssetDetailsByPolicy :: Text -> IO [Text]
getAssetDetailsByPolicy p = do
    project <- getProject
    result <- runBlockfrost project $ do
                    assets <- getAssetsByPolicy' (PolicyId p) (Paged {countPerPage = 9, pageNumber = 1}) Descending
                    assetsDetails <- mapM ((getAssetDetails . AssetId) . _assetInfoAsset) assets

                    return (map getAssetName assetsDetails)

    return case result of
                Left e  -> []
                Right t -> t

    where
    getAssetName = maybe "No asset info" _assetOnChainMetadataName . _assetDetailsOnchainMetadata

getAccountByStake :: Text -> IO Text
getAccountByStake stake = do
    project <- getProject
    result <- runBlockfrost project $ do
            getAccount (Address stake)

    let r = case result of
            Left e -> parseBFError e
            Right a -> do
                let isActive = _accountInfoActive a
                trace (T.unpack $ show isActive) "test"

    return r

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
