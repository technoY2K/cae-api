module Web.View.Dashboard.Index where
import           Web.View.Prelude

newtype IndexView = IndexView { userEmail :: Maybe Text }

instance View IndexView where
    html IndexView { userEmail }= [hsx|
        <h1>Welcome</h1>
        <div>
            <p>This is the Dashboard{renderGreeting}</p>
        </div>
    |]

        where
            renderGreeting = case userEmail of
                Just t  -> ", Hello " <> t
                Nothing -> ", Please login!"
