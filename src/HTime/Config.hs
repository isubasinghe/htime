{-# LANGUAGE OverloadedStrings #-}

module HTime.Config where

import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Bifunctor as B
import Toml

data Path = Path
  { path :: !Text,
    enforceProjectName :: !(Maybe Bool),
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
    <*> Toml.dioptional (Toml.bool "enforce-project-name") .= enforceProjectName
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
      enforceProjectName = Just True,
      enforceNTags = Nothing,
      enforceDescription = Nothing,
      autoFillProjectName = Just "pipekit",
      autoFillTags = Just ["argo-workflows", "open-source"],
      autoFillDescription = Nothing
    }

exampleConfig :: Config
exampleConfig = Config [examplePath, examplePath]

configFromFile :: Text -> IO (Either Text Config)
configFromFile t = do
  fileData <- TIO.readFile (T.unpack t)
  pure $ B.first Toml.prettyTomlDecodeErrors (Toml.decode configCodec fileData)


defaultConfig :: Config
defaultConfig = undefined
