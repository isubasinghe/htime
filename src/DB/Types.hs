{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module DB.Types where

import Control.Monad.Trans.Class
import qualified Data.Set as S
import Data.Text (Text)
import Database.Selda

type Tags = S.Set Text

data Entry = Entry
  { estart :: Int,
    eend :: Maybe Int,
    eprojectName :: Maybe Text,
    eTags :: Tags,
    description :: Maybe Text
  }

class MQuery a where
  start :: Maybe Int
  end :: Maybe Int
  projectFilter :: Maybe (Entry -> Bool)

{- class (Monad b) => DBEngine b where
  writeInterval :: Entry -> b Bool
  deleteInterval :: Entry -> b Bool
  listIntervals :: b [Entry]
  queryInterval :: Query a => a -> b c -}

data Entities = EEntry Entry | ETags Tags

class (MonadTrans m) => DBEngine m 

type ABC = SeldaT Char IO Int

asd :: ABC
asd = pure 23



