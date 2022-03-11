module Web.Controller.Posts where

import           Blockfrost.Client
import qualified Data.Text              as T
import qualified Text.MMark             as MMark
import           Web.Controller.Prelude
import           Web.View.Posts.Edit
import           Web.View.Posts.Index
import           Web.View.Posts.New
import           Web.View.Posts.Show

instance Controller PostsController where
    action PostsAction = do
        project <- projectFromFile ".env"
        result <- runBlockfrost project $ do
                    ats <- getAssetsByPolicy "c364930bd612f42e14d156e1c5410511e77f64cab8f2367a9df544d1"
                    if length ats > 1
                        then
                            do
                                let asset = ats !! 1
                                details <- getAssetDetails $ AssetId (_assetInfoAsset asset)
                                case _assetDetailsOnchainMetadata details of
                                    Nothing -> return ("No asset meta data" :: T.Text)
                                    Just d  -> return (_assetOnChainMetadataName d)

                        else return "Not enough assets"

        case result of
            Left e  -> renderPlain e
            Right t -> renderPlain t

    action NewPostAction = do
        let post = newRecord
        render NewView { .. }

    action ShowPostAction { postId } = do
        post <- fetch postId
            >>= pure . modify #comments (orderByDesc #createdAt)
            >>= fetchRelated #comments
        render ShowView { post }

    action EditPostAction { postId } = do
        post <- fetch postId
        render EditView { .. }

    action UpdatePostAction { postId } = do
        post <- fetch postId
        post
            |> buildPost
            |> ifValid \case
                Left post -> render EditView { .. }
                Right post -> do
                    post <- post |> updateRecord
                    setSuccessMessage "Post updated"
                    redirectTo EditPostAction { .. }

    action CreatePostAction = do
        let post = newRecord @Post
        post
            |> buildPost
            |> ifValid \case
                Left post -> render NewView { .. }
                Right post -> do
                    post <- post |> createRecord
                    setSuccessMessage "Post created"
                    redirectTo PostsAction

    action DeletePostAction { postId } = do
        post <- fetch postId
        deleteRecord post
        setSuccessMessage "Post deleted"
        redirectTo PostsAction

buildPost post = post
    |> fill @["title","body"]
    |>  validateField #title nonEmpty
    |>  validateField #body nonEmpty
    |>  validateField #body isMarkDown

isMarkDown :: Text -> ValidatorResult
isMarkDown text =
    case MMark.parse "" text of
        Left _  -> Failure "Please provide valid Markdown"
        Right _ -> Success
