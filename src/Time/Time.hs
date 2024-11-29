
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveAnyClass #-}

module Time.Time where

import Control.Monad.Reader
import Data.Map

newtype AppT m a = AppT { unAppT :: ReaderT (Map String String) m a}
  deriving(Functor, Applicative, Monad, MonadIO)

