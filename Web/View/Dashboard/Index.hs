module Web.View.Dashboard.Index where
import           Web.View.Prelude

data IndexView = IndexView

instance View IndexView where
    html IndexView = [hsx|
        <h1>Welcome</h1>
        <div>
            <p>This is the Dashboard</p>
        </div>
    |]
