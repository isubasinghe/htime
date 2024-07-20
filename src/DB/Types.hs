{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module DB.Types where

import Control.Monad.Trans.Class
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

