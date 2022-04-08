module Web.Routes where
import           Generated.Types
import           IHP.RouterPrelude
import           Web.Types

-- Generator Marker
instance AutoRoute StaticController
instance AutoRoute PostsController
instance AutoRoute CommentsController
instance AutoRoute SessionsController
instance AutoRoute UsersController
instance AutoRoute AssetsController
instance AutoRoute WalletsController

instance CanRoute DashboardController where
    parseRoute' = string "/Dashboard" <* endOfInput >> pure DashboardAction

instance HasPath DashboardController where
    pathTo DashboardAction = "/Dashboard"
