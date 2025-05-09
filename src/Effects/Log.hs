module Effects.Log where
import Control.Monad.IO.Class
import qualified Katip as K
import App.Monad (AppEnv, App, runAppAsIO)
import App.Error (AppError)
import Relude.Monad.Either (whenLeft)
import Control.Monad.Except (MonadError(throwError))



runAppLogIO :: AppEnv -> App a -> IO (Either AppError a)
runAppLogIO env app = do
  appRes <- runAppAsIO env app
  logRes <- whenLeft (Right ()) appRes (logMPErrorIO env)
  pure $ appRes <* logRes

logMPErrorIO :: AppEnv -> AppError -> IO (Either AppError ())
logMPErrorIO env err = runAppAsIO env $ throwError err
