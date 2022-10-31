{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module DB.Selda where

import qualified DB.Types as D
import Database.Selda
import Control.Monad.Trans.Class

instance SqlRow Project

instance SqlRow Tag

instance SqlRow Entry

data Entry = Entry
  { eid :: ID Entry,
    estart :: Int,
    eend :: Maybe Int,
    eproject :: ID Project,
    description :: Maybe Text
  }
  deriving (Generic)

data Project = Project {pid :: ID Project, pname :: Text}
  deriving (Generic)

data Tag = Tag {tid :: ID Tag, eidFk :: ID Entry, tname :: Text}
  deriving (Generic)

entry :: Table Entry
entry = table "entry" [#eid :- autoPrimary]

project :: Table Project
project = table "project" [#pid :- autoPrimary, #pname :- index]

tag :: Table Tag
tag = table "tag" [#tid :- autoPrimary, #tname :- index, #eidFk :- index, #eidFk :- foreignKey entry #eid]


