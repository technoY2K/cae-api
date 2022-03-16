module Web.View.Users.New where
import           Web.View.Prelude

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { user } = [hsx|
        {breadcrumb}
        <h1>Create a new user</h1>
        {renderForm user}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Users" UsersAction
                , breadcrumbText "New User"
                ]

renderForm :: User -> Html
renderForm user = formFor user [hsx|
    {(textField #email)}
    {(passwordField #passwordHash) {fieldLabel ="Password"}}
    {submitButton}
|]
