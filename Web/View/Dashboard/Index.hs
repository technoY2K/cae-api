module Web.View.Dashboard.Index where
import           Web.View.Prelude

newtype IndexView = IndexView { userEmail :: Maybe Text }

instance View IndexView where
    html IndexView { userEmail }= [hsx|
        <h1>Welcome</h1>
        <div>
            {renderMsg}
        </div>
    |]

        where
            renderMsg = case userEmail of
                Just email  -> [hsx|<p>Hello, {email}</p>|]
                Nothing -> [hsx|
                                <p>Please <a href={NewSessionAction}>Login</a></p>
                            |]
