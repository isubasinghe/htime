
module DB.DBManager where
import DB.Types (Entry)

data DBManager = DBManager 
  { directory :: String
  }

splitEntry :: Entry -> [Entry]
splitEntry e = undefined

writeEntry :: Entry -> DBManager -> IO ()
writeEntry e db = undefined
