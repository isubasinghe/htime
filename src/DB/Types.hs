{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module DB.Types where

import qualified Data.Set as S
import Data.Text (Text)

type Tags = S.Set Text


data Entry = Entry
  { estart :: Int,
    eend :: Maybe Int,
    eprojectName :: Maybe Text,
    eTags :: Tags,
    description :: Maybe Text
  }

class Query where
  start :: Maybe Int
  end :: Maybe Int
  projectFilter :: Maybe (Entry -> Bool)

class Monad b => DBEngine a b c where
  writeInterval :: a -> b c
  deleteInterval :: a -> b c
  listIntervals :: b [a]
  queryInterval :: a -> b c
