module Web.Controller.Assets where
import           Web.Common.CardanoAPI  as C
import           Web.Controller.Prelude

instance Controller AssetsController where
    action ShowPolicyAction = do
        let policy = param @Text "policyid"
        r <- C.getAssetDetailsByPolicy policy

        renderJson r
