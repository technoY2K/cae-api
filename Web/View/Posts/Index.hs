module Web.View.Posts.Index where
import           Data.Aeson
import           Web.View.Prelude

newtype IndexView = IndexView { posts :: [Post]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewPostAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Post</th>
                    </tr>
                </thead>
                <tbody>{forEach posts renderPost}</tbody>
            </table>

        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                ]

    json IndexView { .. } = toJSON posts

renderPost :: Post -> Html
renderPost post = [hsx|
    <tr>
        <td><ol>{get #title post}</ol></td>
        <td><a href={ShowPostAction (get #id post)}>Show</a></td>
        <td><a href={EditPostAction (get #id post)} class="text-muted">Edit</a></td>
        <td><a href={DeletePostAction (get #id post)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]

instance ToJSON Post where
    toJSON post = object
        [ "id" .= get #id post
        , "title" .= get #title post
        , "body" .= get #body post
        ]
