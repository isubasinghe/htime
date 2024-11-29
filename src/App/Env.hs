{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE TypeSynonymInstances #-}

module App.Env(Env) where
import Data.Kind (Type)

data Env (m :: Type -> Type) = Env {
  rootPath :: String
}



