module Web.Controller.Dashboard where

import           Web.Controller.Prelude

instance Controller DashboardController where
    action DashboardAction = renderPlain "Yeah"

