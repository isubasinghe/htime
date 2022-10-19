module Main (main) where

import CLI
import Options.Applicative hiding (command)
import TUI
import qualified HTime.Engine as HE

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
  let cFile = configFile c 
  _ <- HE.runWith cFile HE.debugFn
  pure ()
