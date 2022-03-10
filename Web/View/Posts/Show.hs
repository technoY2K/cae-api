module Web.View.Posts.Show where
import qualified Text.MMark       as MMark
import           Web.View.Prelude

newtype ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { post } = [hsx|
        {breadcrumb}
        <h2>{get #title post}</h2>
        <p>{get #createdAt post |> timeAgo}</p>
        <div>{get #body post |> renderMarkdown}</div>
        <div>{forEach (get #comments post) renderComment}</div>
        <hr>
        <a href={NewCommentAction (get #id post)}>Add Comment</a>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

            renderMarkdown text =
                case text |> MMark.parse "" of
                    Left error -> "Oops! Something went wrong"
                    Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

            renderComment comment = [hsx|
                <div class="mt-4">
                    <h5>{get #author comment}</h5>
                    <p>{get #body comment}</p>
                </div>
            |]
