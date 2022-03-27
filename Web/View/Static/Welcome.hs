module Web.View.Static.Welcome where
import           Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
            <div style="background-color: #2a71d0; padding-top: 2rem; padding-bottom: 2rem; color:hsla(196, 13%, 96%, 1); border-radius: 4px">
                <div style="max-width: 800px; margin-left: auto; margin-right: auto">
                    <h2 style="margin-top: 0; margin-bottom: 0rem; font-weight: 900; font-size: 3rem">
                        Cardano Asset Explorer
                    </h2>
                </div>
            </div>
            <div>
                {renderForm}
            </div>
        |]
        where
            renderForm = [hsx|
                <form id="main-form" method="GET" action={DashboardAction}>
                    <input type="text" name="policyid" class="form-control"/>
                    <input type="submit" class="btn btn-primary"/>
                </form>
                |]

