module Main (main) where

import CLI
import Options.Applicative hiding (command)
import TUI

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

runHTime :: CLIOptions -> IO ()
runHTime c = do
  print c
