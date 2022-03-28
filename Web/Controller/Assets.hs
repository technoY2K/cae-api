module Web.Controller.Assets where

import           Web.Controller.Prelude
import           Web.View.Assets.Show

instance Controller AssetsController where
    action ShowPolicyAction = render ShowView
