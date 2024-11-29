{-# LANGUAGE LinearTypes #-}

module Time.Store (mkEntry) where
import Time.Entry
import System.IO (Handle)




mkEntry :: Handle -> Entry -> IO ()
mkEntry f e = do
  undefined
