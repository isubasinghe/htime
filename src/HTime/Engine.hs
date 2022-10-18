{-# LANGUAGE OverloadedStrings #-}

module HTime.Engine where

import Data.Maybe (fromMaybe)
import qualified Data.Text as T
import HTime.Config (Config, configFromFile, defaultConfig)
import System.Directory (createDirectoryIfMissing, doesFileExist, getHomeDirectory)
import System.FilePath ((</>))

newtype Engine = Engine {config :: Config}

runWith :: Maybe FilePath -> IO Config
runWith configLoc = do
  home <- maybe getHomeDirectory pure configLoc
  let htimeFolder = fromMaybe (home </> ".htime") configLoc
  createDirectoryIfMissing False htimeFolder
  fileExists <- doesFileExist (htimeFolder </> "config.toml")
  if fileExists
    then do
      ces <- configFromFile $ T.pack (htimeFolder </> "config.toml")
      case ces of
        Left e -> error (T.unpack e)
        Right c -> pure c
    else pure defaultConfig
