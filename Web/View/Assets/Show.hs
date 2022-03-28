module Web.View.Assets.Show where
import           Web.Types
import           Web.View.Prelude

data ShowView = ShowView { policyName :: Text}

instance View ShowView where
    html ShowView {..} = [hsx|
        <div>
            <h1>Project: </h1>
            <p>{policyName}</p>
        </div>

    |]
