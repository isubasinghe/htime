module CLI where

import Options.Applicative hiding (command)
import qualified Options.Applicative as O

data CLIOptions = CLIOptions {configFile :: Maybe FilePath, command :: Command}
  deriving (Show, Eq)

cliOptions :: Parser CLIOptions
cliOptions =
  CLIOptions
    <$> optional
      ( strOption
          ( long "config"
              <> metavar "CONFIG"
          )
      )
    <*> parseCommand

type From = String

type To = String

type Project = String

type Tag = String

type Tags = [Tag]

data AddOptions = AddOptions From To Project Tags
  deriving (Show, Eq)

data StartOptions = StartOptions Project Tags
  deriving (Show, Eq)

data StopOptions = StopOptions
  deriving (Show, Eq)

data Command
  = Add AddOptions
  | Start StartOptions
  | Stop StopOptions
  deriving (Show, Eq)

parseCommand :: Parser Command
parseCommand =
  subparser
    ( O.command "add" (info addCommand (progDesc "Add a new frame to the existing database"))
        <> O.command "start" (info startCommand (progDesc "Start time monitoring on a project"))
        <> O.command "stop" (info stopCommand (progDesc "Stop the ongoing time monitoring"))
    )

addOptions :: Parser AddOptions
addOptions =
  AddOptions
    <$> strOption
      ( long "from"
          <> metavar "TIME"
          <> help "Target for the starting time"
      )
    <*> strOption
      ( long "to"
          <> metavar "TIME"
          <> help "Target for the ending time"
      )
    <*> strOption
      ( long "project"
          <> metavar "PROJECT"
          <> help "Name of the project to add a new time frame to"
      )
    <*> many
      ( strOption
          ( long "tag"
              <> short 't'
              <> metavar "TAG"
          )
      )

startOptions :: Parser StartOptions
startOptions =
  StartOptions
    <$> strOption
      ( long "project"
          <> metavar "PROJECT"
          <> help "Name of the project to start"
      )
    <*> many
      ( strOption
          ( long "tag"
              <> short 't'
              <> metavar "TAG"
          )
      )

stopOptions :: Parser StopOptions
stopOptions = pure StopOptions

addCommand :: Parser Command
addCommand = Add <$> addOptions

startCommand :: Parser Command
startCommand = Start <$> startOptions

stopCommand :: Parser Command
stopCommand = Stop <$> stopOptions
