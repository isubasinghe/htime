module Config where
import Control.Monad.IO.Class
data Config = Config {
  file :: String
}

loadConfig :: MonadIO m => m Config
loadConfig = do
  pure Config{ file = "hello.yaml"}
