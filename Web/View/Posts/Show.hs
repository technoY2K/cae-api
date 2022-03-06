module Web.View.Posts.Show where
import           Web.View.Prelude

newtype ShowView = ShowView { post :: Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h2>{get #title post}</h2>
        <p>{get #createdAt post |> timeAgo}</p>
        <div>{get #body post}</div>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]
