module Reconcile where

import CLI
import qualified Data.Bifunctor as B
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import HTime.Config
import System.Directory (createDirectoryIfMissing, doesFileExist, getCurrentDirectory, getHomeDirectory)
import System.FilePath ((</>))
import Control.Applicative ((<|>))
import qualified Toml

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

data ReconcilitionError
  = RequiresFrom
  | RequiresTo
  | RequiresProject
  | RequiresTags Int Int
  deriving (Show, Eq)

reconcile :: FilePath -> Config -> Command -> Either ReconcilitionError Command
reconcile cd c cmd =
  let maybeVal = searchConfig c cd
   in let val = fromMaybe (defaultPathFrom cd) maybeVal
       in case cmd of
            (Add (AddOptions from to mproject tags)) -> do
              project <- cproj mproject val
              tags' <- ctags tags val
              pure $ Add (AddOptions from to project tags')
            (Start (StartOptions mprojects tags)) -> do
              project <- cproj mprojects val
              tags' <- ctags tags val
              pure $ Start (StartOptions project tags')
            (Stop StopOptions) -> pure $ Stop StopOptions
  where
    cproj :: Maybe Project -> Path -> Either ReconcilitionError (Maybe Project)
    cproj mproj p = let v = mproj <|> autoFillProjectName p
                     in case (v, enforceProjectName p)  of 
                          (Just x, _) -> pure $ Just x 
                          (_, True) -> Left RequiresProject
                          _ -> pure Nothing
                          
    ctags :: Tags -> Path -> Either ReconcilitionError Tags
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
