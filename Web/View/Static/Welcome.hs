module Web.View.Static.Welcome where
import           Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
    html WelcomeView = [hsx|
         <div style="background-color: #2a71d0; padding-top: 2rem; padding-bottom: 2rem; color:hsla(196, 13%, 96%, 1); border-radius: 4px">
              <div style="max-width: 800px; margin-left: auto; margin-right: auto">
                  <h2 style="margin-top: 0; margin-bottom: 0rem; font-weight: 900; font-size: 3rem">
                      Welcome to the Cardano Assets Tracker
                  </h2>
              </div>
         </div>

         <div style="max-width: 800px; margin-left: auto; margin-right: auto; margin-top: 4rem">
              <img src="/welcome-chart.svg" alt="/welcome-chart">
         </div>
|]
