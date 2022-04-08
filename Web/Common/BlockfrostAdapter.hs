module Web.Common.BlockfrostAdapter where

import           Blockfrost.Client
import           IHP.Prelude

getProject :: IO Project
getProject = projectFromFile ".blockfrost"
