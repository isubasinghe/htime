module Lib
  ( main,
  )
where
import Config (Config, loadConfig)
import App.Monad (AppEnv)


mkAppEnv :: Config -> IO AppEnv
mkAppEnv = undefined

runApp :: AppEnv -> IO ()
runApp = undefined

main :: IO ()
main = loadConfig >>= mkAppEnv >>= runApp
