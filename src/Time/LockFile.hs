module Time.LockFile where

class (Monad m, MonadFail m) => MonadLock m where
  tryAcquireLock :: m Bool
  releaseLock :: m ()
