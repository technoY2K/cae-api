module Web.View.Layout (defaultLayout, Html) where

import           Application.Helper.View       ()
import           Generated.Types               ()
import           IHP.Controller.RequestContext ()
import           IHP.Environment               ()
import           IHP.ViewPrelude               (Html, Maybe (Just, Nothing),
                                                assetPath, autoRefreshMeta,
                                                currentUserOrNothing, hsx,
                                                isDevelopment,
                                                liveReloadWebsocketUrl,
                                                pageTitleOrDefault,
                                                renderFlashMessages, when, (!),
                                                ($))
import qualified Text.Blaze.Html5              as H
import qualified Text.Blaze.Html5.Attributes   as A
import           Web.Routes                    ()
import           Web.Types                     (DashboardController (DashboardAction),
                                                SessionsController (DeleteSessionAction, NewSessionAction))

defaultLayout :: Html -> Html
defaultLayout inner = H.docTypeHtml ! A.lang "en" $ [hsx|
<head>
    {metaTags}

    {stylesheets}
    {scripts}

    <title>{pageTitleOrDefault "CAE"}</title>
</head>
<body>
    <div class="container mt-4">
        {renderFlashMessages}
        {renderNav}
        {inner}
    </div>
</body>
|]

    where
        renderNav = [hsx|
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <a class="navbar-brand" href="/">Home</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav">
                    <li class="nav-item px-2">
                        <a class="js-delete js-delete-no-confirm" href={DashboardAction}>Dashboard</a>
                    </li>
                    <li class="nav-item px-2">
                        {authUser}
                    </li>
                    </ul>
                </div>
            </nav>
        |]

        authUser = case currentUserOrNothing of
            Nothing   -> [hsx|<a href={NewSessionAction}>Login</a>|]
            Just user -> [hsx|<a class="js-delete js-delete-no-confirm" href={DeleteSessionAction}>Logout</a>|]

-- The 'assetPath' function used below appends a `?v=SOME_VERSION` to the static assets in production
-- This is useful to avoid users having old CSS and JS files in their browser cache once a new version is deployed
-- See https://ihp.digitallyinduced.com/Guide/assets.html for more details

stylesheets :: Html
stylesheets = [hsx|
        <link rel="stylesheet" href={assetPath "/vendor/bootstrap.min.css"}/>
        <link rel="stylesheet" href={assetPath "/vendor/flatpickr.min.css"}/>
        <link rel="stylesheet" href={assetPath "/app.css"}/>
    |]

scripts :: Html
scripts = [hsx|
        {when isDevelopment devScripts}
        <script src={assetPath "/vendor/jquery-3.6.0.slim.min.js"}></script>
        <script src={assetPath "/vendor/timeago.js"}></script>
        <script src={assetPath "/vendor/popper.min.js"}></script>
        <script src={assetPath "/vendor/bootstrap.min.js"}></script>
        <script src={assetPath "/vendor/flatpickr.js"}></script>
        <script src={assetPath "/vendor/morphdom-umd.min.js"}></script>
        <script src={assetPath "/vendor/turbolinks.js"}></script>
        <script src={assetPath "/vendor/turbolinksInstantClick.js"}></script>
        <script src={assetPath "/vendor/turbolinksMorphdom.js"}></script>
        <script src={assetPath "/helpers.js"}></script>
        <script src={assetPath "/ihp-auto-refresh.js"}></script>
        <script src={assetPath "/app.js"}></script>
    |]

devScripts :: Html
devScripts = [hsx|
        <script id="livereload-script" src={assetPath "/livereload.js"} data-ws={liveReloadWebsocketUrl}></script>
    |]

metaTags :: Html
metaTags = [hsx|
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta property="og:title" content="App"/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="TODO"/>
    <meta property="og:description" content="TODO"/>
    {autoRefreshMeta}
|]
