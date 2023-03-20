{-# LANGUAGE OverloadedStrings #-}

module HTime.Config where

import qualified Data.Bifunctor as B
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Toml

data Path = Path
  { path :: !Text,
    enforceProjectName :: !Bool,
    enforceNTags :: !(Maybe Int),
    enforceDescription :: !(Maybe Bool),
    autoFillProjectName :: !(Maybe Text),
    autoFillTags :: !(Maybe [Text]),
    autoFillDescription :: !(Maybe Text)
  }
  deriving (Show, Eq)

newtype Config = Config {paths :: [Path]}
  deriving (Show, Eq)

pathCodec :: TomlCodec Path
pathCodec =
  Path
    <$> Toml.text "path" .= path
    <*> Toml.bool "enforce-project-name" .= enforceProjectName
    <*> Toml.dioptional (Toml.int "enforce-n-tags") .= enforceNTags
    <*> Toml.dioptional (Toml.bool "enforce-description") .= enforceDescription
    <*> Toml.dioptional (Toml.text "autofill-project-name") .= autoFillProjectName
    <*> Toml.dioptional (Toml.arrayOf Toml._Text "autofill-tags") .= autoFillTags
    <*> Toml.dioptional (Toml.text "autofill-description") .= autoFillDescription

configCodec :: TomlCodec Config
configCodec =
  Config
    <$> Toml.list pathCodec "paths" .= paths

-- configCodec :: TomlCodec Config
examplePath :: Path
examplePath =
  Path
    { path = "~/Projects/lwfree",
      enforceProjectName = True,
      enforceNTags = Nothing,
      enforceDescription = Nothing,
      autoFillProjectName = Just "pipekit",
      autoFillTags = Just ["argo-workflows", "open-source"],
      autoFillDescription = Nothing
    }

exampleConfig :: Config
exampleConfig = Config [examplePath, examplePath]

defaultConfig :: Config
defaultConfig = Config []

defaultPathFrom :: FilePath -> Path
defaultPathFrom fpath =
  Path
    { path = T.pack fpath,
      enforceProjectName = False,
      enforceNTags = Nothing,
      enforceDescription = Nothing,
      autoFillProjectName = Nothing,
      autoFillTags = Nothing,
      autoFillDescription = Nothing
    }

searchConfig :: Config -> FilePath -> Maybe Path
searchConfig (Config []) _ = Nothing
searchConfig (Config (p : ps)) f = if path p == T.pack f then Just p else searchConfig (Config ps) f
