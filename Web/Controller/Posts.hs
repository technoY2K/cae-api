module Web.Controller.Posts where

import           BasicPrelude
import           Blockfrost.Client
import qualified Data.ByteString.Lazy   as BL
import qualified Data.Text              as T
import qualified Text.MMark             as MMark
import           Web.Controller.Prelude
import           Web.View.Posts.Edit
import           Web.View.Posts.Index
import           Web.View.Posts.New     (NewView (NewView, post))
import           Web.View.Posts.Show

data Dummy = Dummy
    { pig     :: Text
    , rooster :: Text
    , snake   :: Text
    }

mkDummy :: Dummy
mkDummy = Dummy { pig = "IGNORANCE", rooster = "DESIRE", snake = "HATE"}

instance ToJSON Dummy where
    toJSON d = object ["pig" .= pig d, "rooster" .= rooster d, "snake" .= snake d]

instance Controller PostsController where
    action PostsAction = renderJson mkDummy

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

convert :: Text -> BL.ByteString
convert = BL.fromChunks . return . encodeUtf8

parseBFError :: BlockfrostError -> Text
parseBFError b = case b of
    BlockfrostError t        -> t
    BlockfrostBadRequest t   -> t
    BlockfrostTokenMissing t -> t
    BlockfrostFatal t        -> t
    _                        -> "Unknow error"

