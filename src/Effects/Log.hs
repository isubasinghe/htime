module Effects.Log where
import Control.Monad.IO.Class
import qualified Katip as K

mainLogAction:: MonadIO m => K.Severity -> K.KatipContextT m ()
mainLogAction = undefined

simpleLog :: K.KatipContextT IO ()
simpleLog  = do
  _ <- K.logFM K.InfoS ""
  pure ()
