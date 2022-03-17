module Web.Controller.Sessions where

import qualified IHP.AuthSupport.Controller.Sessions as Sessions
import           Web.Controller.Prelude              (Controller (action),
                                                      SessionsController (..),
                                                      User,
                                                      User' (email, failedLoginAttempts, id, passwordHash))
import           Web.View.Sessions.New               ()

instance Controller SessionsController where
    action NewSessionAction    = Sessions.newSessionAction @User
    action CreateSessionAction = Sessions.createSessionAction @User
    action DeleteSessionAction = Sessions.deleteSessionAction @User

instance Sessions.SessionsControllerConfig User
