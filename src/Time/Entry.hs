{-# LANGUAGE MultiParamTypeClasses #-}
module Time.Entry (Entry(..)) where

data Entry = Entry 
  { project :: String
  , tags :: [String]
  , from :: String
  , to :: String
  }


  
