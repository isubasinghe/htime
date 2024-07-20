{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE BlockArguments #-}

module TaskBuilder.TaskBuilder where
import Control.Monad.RWS (MonadState)
import Data.Hashable (Hashable, hash)
import Control.Applicative


data Store i k v = Stored i (k -> v)

initialise :: i -> (k -> v) -> Store i k v
initialise = Stored

getInfo :: Store i k v -> i
getInfo (Stored i _) = i

putInfo :: i -> Store i k v -> Store i k v
putInfo i' (Stored _ fn) = Stored i' fn

getValue :: k -> Store i k v -> v
getValue k (Stored _ fn) = fn k

putValue :: Eq k => k -> v -> Store i k v -> Store i k v
putValue k v (Stored i fn) = Stored i (\k' -> if k' == k then v else fn k')


data Hash v = Hashed v Int

hash' :: Hashable v => v -> Hash v
hash' v = Hashed v (hash v)

getHash :: Hashable v => k -> Store i k v -> Hash v
getHash k' (Stored _ fn) = hash' $ fn k'

newtype Task c k v = Task { run :: forall f. c f => (k -> f v) -> f v }
type Tasks c k v = k -> Maybe (Task c k v)

type Build c i k v = Tasks c k v -> k -> Store i k v -> Store i k v

type Scheduler c i ir k v = Rebuilder c ir k v -> Build c i k v
type Rebuilder c   ir k v = k -> v -> Task c k v -> Task (MonadState ir) k v


