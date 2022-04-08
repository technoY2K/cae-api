module Web.Common.CardanoAPI where

import           Blockfrost.Client
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

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
