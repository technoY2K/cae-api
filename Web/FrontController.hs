module Web.FrontController where

import           IHP.RouterPrelude
import           Web.Controller.Prelude
import           Web.View.Layout          (defaultLayout)

-- Controller Imports
import           Web.Controller.Comments
import           Web.Controller.Dashboard
import           Web.Controller.Posts
import           Web.Controller.Static

instance FrontController WebApplication where
    controllers =
        [ startPage WelcomeAction
        -- Generator Marker
        , parseRoute @CommentsController
        , parseRoute @PostsController
        , parseRoute @DashboardController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
