module Web.Controller.Assets where

import           Blockfrost.Client
import           Web.Controller.Prelude
import           Web.View.Assets.Show

instance Controller AssetsController where
    action ShowPolicyAction = do
        project <- projectFromFile ".blockfrost"
        result <- runBlockfrost project $ do
                    let id = param @Text "policyid"
                    ats <- getAssetsByPolicy (PolicyId id)
                    case ats of
                        (x:y:zs) -> do
                            details <- getAssetDetails $ AssetId (_assetInfoAsset x)
                            case _assetDetailsOnchainMetadata details of
                                Nothing -> return ("No asset meta data" :: Text)
                                Just d  -> return (_assetOnChainMetadataName d)

                        _ -> return "Not enough assets"

        let pn = case result of
                Left e  -> parseBFError e
                Right t -> t

        renderJson pn


parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
