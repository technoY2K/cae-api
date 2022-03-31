module Web.Controller.Assets where

import           Blockfrost.Client
import           Web.Controller.Prelude

instance Controller AssetsController where
    action ShowPolicyAction = do
        project <- projectFromFile ".blockfrost"
        result <- runBlockfrost project $ do
                    let id = param @Text "policyid"
                    assets <- getAssetsByPolicy' (PolicyId id) (Paged {countPerPage = 9, pageNumber = 1}) Descending
                    assetsDetails <- mapM ((getAssetDetails . AssetId) . _assetInfoAsset) assets

                    return ( map getAssetName assetsDetails)

        let pn = case result of
                Left e  -> []
                Right t -> t

        renderJson pn

        where
            getAssetName a = maybe "No asset info" _assetOnChainMetadataName (_assetDetailsOnchainMetadata y)


parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
