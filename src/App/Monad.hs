module App.Monad where

import Control.Monad.Except
import Control.Monad.Reader (ReaderT(..), MonadReader)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Exception(throwIO, catch)
import App.Env (Env)
import App.Error 
import Relude.Monad.Trans(usingReaderT)

type AppEnv = Env App

newtype App a = App {
  unApp :: ReaderT AppEnv IO a
} deriving(Functor, Applicative, Monad, MonadIO, MonadReader AppEnv)

instance MonadError AppError App where
    throwError :: AppError -> App a
    throwError a = liftIO $ throwIO (AppException a)
    {-# INLINE throwError #-}

    catchError :: App a -> (AppError -> App a) -> App a
    catchError action handler = App $ ReaderT $ \env -> do
      let ioAction = runApp env action
      ioAction `catch` \(AppException e) -> runApp env $ handler e


runApp :: AppEnv -> App a -> IO a
runApp env = usingReaderT env . unApp
