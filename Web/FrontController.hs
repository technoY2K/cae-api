module Web.FrontController where

import           IHP.RouterPrelude           (FrontController (..), parseRoute,
                                              startPage)
import           Web.Controller.Prelude      (CommentsController,
                                              DashboardController (DashboardAction),
                                              FrontController (..),
                                              InitControllerContext (..),
                                              PostsController,
                                              SessionsController, User,
                                              UsersController, WebApplication,
                                              initAutoRefresh, parseRoute,
                                              setLayout, startPage)
import           Web.View.Layout             (defaultLayout)

-- Controller Imports
import           IHP.LoginSupport.Middleware (initAuthentication)
import           Web.Controller.Comments     ()
import           Web.Controller.Dashboard    ()
import           Web.Controller.Posts        ()
import           Web.Controller.Sessions     ()
import           Web.Controller.Static       ()
import           Web.Controller.Users        ()

instance FrontController WebApplication where
    controllers =
        [ startPage DashboardAction
        -- Generator Marker
        , parseRoute @UsersController
        , parseRoute @CommentsController
        , parseRoute @PostsController
        , parseRoute @SessionsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
