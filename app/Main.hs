{-# LANGUAGE FlexibleContexts #-}

module Main (main) where

import CLI
import Options.Applicative hiding (command)

main :: IO ()
main = runProgram =<< execParser opts
  where
    opts =
      info
        (cliOptions <**> helper)
        ( fullDesc
            <> progDesc "HTime is a haskell time monitoring tool very much inspired from Watson"
            <> header "λ :: HTime"
        )


runProgram :: CLIOptions -> IO () 
runProgram _ = putStrLn "Not Finished"
