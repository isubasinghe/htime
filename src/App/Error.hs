{-# LANGUAGE DeriveAnyClass #-}

module App.Error (AppError, AppException(..), IError, AppErrorType) where

import Control.Exception (Exception)
import Control.Monad.Except (MonadError)
import qualified Control.Monad.Except as E (throwError)
import Data.Text (Text)
import qualified Data.Text as T (pack)
import GHC.Stack (CallStack, HasCallStack, SrcLoc (SrcLoc, srcLocModule, srcLocStartLine), callStack, getCallStack)

-- | Type alias for errors.
type WithError m = (MonadError AppError m, HasCallStack)

-- | Specialized version of 'E.throwError'
throwError :: (WithError m) => AppErrorType -> m a
throwError = E.throwError . AppError (toSourcePosition callStack)
{-# INLINE throwError #-}

newtype SourcePosition = SourcePosition Text
  deriving newtype (Show, Eq)

-- | Display 'CallStack' as 'SourcePosition' in a format: @Module.function#line_number@.
toSourcePosition :: CallStack -> SourcePosition
toSourcePosition cs = SourcePosition showCallStack
  where
    showCallStack :: Text
    showCallStack = case getCallStack cs of
      [] -> "<unknown loc>"
      [(name, loc)] -> showLoc name loc
      (_, loc) : (callerName, _) : _ -> showLoc callerName loc

    showLoc :: String -> SrcLoc -> Text
    showLoc name SrcLoc {..} =
      T.pack $ srcLocModule <> "." <> name <> "#" <> show srcLocStartLine

newtype AppException = AppException 
  { unAppException :: AppError
  }
  deriving (Show)
  deriving anyclass (Exception)

data AppError = AppError
  { appErrorCallStack :: SourcePosition,
    appErrorType :: AppErrorType
  }
  deriving (Show, Eq)

-- | App errors type.
newtype AppErrorType = InternalError IError
  deriving (Show, Eq)

data IError = UnknownError String
  deriving (Show, Eq)
