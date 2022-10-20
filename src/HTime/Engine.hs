{-# LANGUAGE OverloadedStrings #-}

module HTime.Engine where

import HTime.Config (Config)

newtype Engine = Engine {config :: Config}
