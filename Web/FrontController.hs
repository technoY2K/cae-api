module Web.FrontController where

import           IHP.RouterPrelude
import           Web.Controller.Prelude
import           Web.View.Layout          (defaultLayout)

-- Controller Imports
import Web.Controller.Users
import           Web.Controller.Comments
import           Web.Controller.Dashboard
import           Web.Controller.Posts
import           Web.Controller.Static

instance FrontController WebApplication where
    controllers =
        [ startPage DashboardAction
        -- Generator Marker
        , parseRoute @UsersController
        , parseRoute @CommentsController
        , parseRoute @PostsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
