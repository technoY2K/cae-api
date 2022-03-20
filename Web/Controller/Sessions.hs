module Web.Controller.Sessions where

import qualified IHP.AuthSupport.Controller.Sessions as Sessions
import           Web.Controller.Prelude              (Controller (action),
                                                      DashboardController (DashboardAction),
                                                      SessionsController (..),
                                                      User,
                                                      User' (email, failedLoginAttempts, id, passwordHash),
                                                      pathTo)
import           Web.View.Sessions.New               ()

instance Controller SessionsController where
    action NewSessionAction    = Sessions.newSessionAction @User
    action CreateSessionAction = Sessions.createSessionAction @User
    action DeleteSessionAction = Sessions.deleteSessionAction @User

instance Sessions.SessionsControllerConfig User where
    afterLoginRedirectPath = pathTo DashboardAction
