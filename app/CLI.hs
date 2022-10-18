module CLI where 
import Options.Applicative

data CLIOptions = CLIOptions { configFile :: Maybe FilePath }

data Commands 
  = Add 
  | Start 
  | Stop 
  | Projects



