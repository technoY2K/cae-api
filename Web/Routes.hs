module Web.Routes where
import           Generated.Types
import           IHP.RouterPrelude
import           Web.Types

-- Generator Marker
instance AutoRoute StaticController
instance AutoRoute PostsController
instance AutoRoute CommentsController

-- Custom Routes
instance CanRoute DashboardController where
    parseRoute' = string "/dashboard" <* endOfInput >> pure DashboardAction

instance HasPath DashboardController where
    pathTo DashboardAction  = "/dashboard"
