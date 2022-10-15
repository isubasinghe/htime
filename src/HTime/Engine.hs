{-# LANGUAGE OverloadedStrings #-}

module HTime.Engine where

import Data.Text (Text)
import qualified Data.Text.IO as TIO
import HTime.Config (Config, configFromFile, defaultConfig)
import System.Directory (createDirectoryIfMissing, getHomeDirectory, doesFileExist)
import System.FilePath ((</>))

data Engine = Engine {config :: Config}

runWith :: Maybe FilePath -> IO ()
runWith configLoc = do
  home <- maybe getHomeDirectory pure configLoc
  let htimeFolder = home </> ".htime"
  createDirectoryIfMissing False htimeFolder
  readFile <- doesFileExist (htimeFolder </> "config.toml")
  if readFile then configFromFile 
  else pure $ defaultConfig

