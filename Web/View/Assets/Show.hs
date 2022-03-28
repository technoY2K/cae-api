module Web.View.Assets.Show where
import           Web.Types
import           Web.View.Prelude

data ShowView = ShowView

instance View ShowView where
    html ShowView = [hsx|
        <h1>Project: </h1>
    |]
