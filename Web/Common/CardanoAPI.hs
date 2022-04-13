module Web.Common.CardanoAPI where

import           Blockfrost.Client
import qualified Data.Text          as T
import qualified Data.Text.Encoding as T
import           Debug.Trace
import           IHP.Prelude
import           Money              (discreteCurrency, someDiscreteCurrency)

getProject :: IO Project
getProject = projectFromFile ".blockfrost"

-- Asset specific API

getAssetDetailsByPolicy :: Text -> IO [Text]
getAssetDetailsByPolicy pId = do
    project <- getProject
    result <- runBlockfrost project $ do
                    assets <- getAssetsByPolicy' (PolicyId pId) (Paged {countPerPage = 9, pageNumber = 1}) Descending
                    assetsDetails <- mapM ((getAssetDetails . AssetId) . _assetInfoAsset) assets
                    let getAssetName = maybe "No asset info" _assetOnChainMetadataName . _assetDetailsOnchainMetadata

                    return (map getAssetName assetsDetails)

    return case result of
                Left e  -> []
                Right t -> t

getAssetsAssociatedByAddress :: Text -> IO [Text]
getAssetsAssociatedByAddress stake = do
    project <- getProject
    result <- runBlockfrost project $ do
                amounts <- getAccountAssociatedAssets (Address stake)
                return case amounts of
                        [] -> ["None"]
                        _  -> map currencyName amounts

                            where
                                currencyName amount = case amount of
                                    AdaAmount dis  -> discreteCurrency dis
                                    AssetAmount sd -> someDiscreteCurrency sd

    return case result of
                Left e  -> []
                Right t -> t

-- Wallet specific API

getAllAddressesByStake :: Text -> IO [Text]
getAllAddressesByStake stake = do
    project <- getProject
    result <- runBlockfrost project $ do
            getAccountAssociatedAddresses (Address stake)

    return case result of
            Left e  -> trace ("Error while fetching addresses " ++ T.unpack (parseBFError e)) []
            Right associatedAddresses  -> map (unAddress . _addressAssociatedAddress) associatedAddresses

-- Util and Helpers

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknown error"
