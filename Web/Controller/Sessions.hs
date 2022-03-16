module Web.Controller.Sessions where

import qualified IHP.AuthSupport.Controller.Sessions as Sessions
import           Web.Controller.Prelude
import           Web.View.Sessions.New

instance Controller SessionsController where
    action NewSessionAction    = Sessions.newSessionAction @User
    action CreateSessionAction = Sessions.createSessionAction @User
    action DeleteSessionAction = Sessions.deleteSessionACtion @User

instance Sessions.SessionsControllerConfig User
