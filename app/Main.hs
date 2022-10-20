module Main (main) where

import CLI
import qualified Data.Bifunctor as B
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import HTime.Config
import Options.Applicative hiding (command)
import System.Directory (createDirectoryIfMissing, doesFileExist, getCurrentDirectory, getHomeDirectory)
import System.FilePath ((</>))
import qualified Toml

main :: IO ()
main = runHTime =<< execParser opts
  where
    opts =
      info
        (cliOptions <**> helper)
        ( fullDesc
            <> progDesc "HTime is a haskell time monitoring tool very much inspired from Watson"
            <> header "λ :: HTime"
        )

configFromFile :: Text -> IO (Either Text Config)
configFromFile t = do
  fileData <- TIO.readFile (T.unpack t)
  pure $ B.first Toml.prettyTomlDecodeErrors (Toml.decode configCodec fileData)

runHTime :: CLIOptions -> IO ()
runHTime c = do
  c' <- getConfig c
  cd <- getCurrentDirectory
  let cmd = command c
  let cmd' = reconcile cd c' cmd
  pure ()

reconcile :: FilePath -> Config -> Command -> Command
reconcile cd c cmd =
  let maybeVal = searchConfig c cd
   in let val = fromMaybe (defaultPathFrom cd) maybeVal
       in case cmd of
            (Add (AddOptions from to mprojects tags)) -> (Add (AddOptions (cfrom from c) (cto to c) (cproj mprojects c) (ctags tags c)))
            (Start (StartOptions mprojects tags)) -> undefined
            (Stop StopOptions) -> undefined
  where
    cfrom from c = undefined
    cto to c = undefined
    cproj mproj c = undefined
    ctags tags c = undefined

getConfig :: CLIOptions -> IO Config
getConfig c = do
  let cFile = configFile c
  home <- maybe getHomeDirectory pure cFile

  let htimeFolder = fromMaybe (home </> ".htime") cFile

  createDirectoryIfMissing False htimeFolder
  fileExists <- doesFileExist (htimeFolder </> "config.toml")
  if fileExists
    then do
      ces <- configFromFile $ T.pack (htimeFolder </> "config.toml")
      case ces of
        Left e -> error (T.unpack e)
        Right c' -> pure c'
    else pure defaultConfig
