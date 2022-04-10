module Web.Common.CardanoAPI where

import           Blockfrost.Client
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           Debug.Trace
import           IHP.Prelude

getProject :: IO Project
getProject = projectFromFile ".blockfrost"

-- Asset specific API

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

-- Wallet specific API

getAllAddressesByStake :: Text -> IO [Text]
getAllAddressesByStake stake = do
    project <- getProject
    result <- runBlockfrost project $ do
            getAccountAssociatedAddresses (Address stake)

    let r = case result of
            Left e  -> trace ("Error while fetching addresses " ++ T.unpack (parseBFError e)) []
            Right a -> map (unAddress . _addressAssociatedAddress) a

    return r

-- Util and Helpers

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
