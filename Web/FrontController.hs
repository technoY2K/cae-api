module Web.FrontController where

import           IHP.RouterPrelude           (FrontController (..), parseRoute,
                                              startPage)
import           Web.Controller.Prelude      (AssetsController,
                                              CommentsController,
                                              DashboardController,
                                              FrontController (..),
                                              InitControllerContext (..),
                                              PostsController,
                                              SessionsController,
                                              StaticController (WelcomeAction),
                                              User, UsersController,
                                              WalletsController, WebApplication,
                                              initAutoRefresh, parseRoute,
                                              setLayout, startPage)
import           Web.View.Layout             (defaultLayout)

-- Controller Imports
import           IHP.LoginSupport.Middleware (initAuthentication)
import           Web.Controller.Assets       ()
import           Web.Controller.Comments     ()
import           Web.Controller.Dashboard    ()
import           Web.Controller.Posts        ()
import           Web.Controller.Sessions     ()
import           Web.Controller.Static       ()
import           Web.Controller.Users        ()
import           Web.Controller.Wallets      ()

instance FrontController WebApplication where
    controllers =
        [ startPage WelcomeAction
        -- Generator Marker
        , parseRoute @UsersController
        , parseRoute @CommentsController
        , parseRoute @PostsController
        , parseRoute @SessionsController
        , parseRoute @DashboardController
        , parseRoute @AssetsController
        , parseRoute @WalletsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
