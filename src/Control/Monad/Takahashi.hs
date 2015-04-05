{-# LANGUAGE GADTs, ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi 
  ( module Control.Monad.Takahashi.API
  , module Control.Monad.Takahashi.Slide
  , module Control.Monad.Takahashi.Monad
  , module Control.Monad.Takahashi.HtmlBuilder
  , module Control.Monad.Takahashi.Util
  ) where
import Control.Lens
import Control.Monad.State

import Control.Monad.Takahashi.API
import Control.Monad.Takahashi.Slide
import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.HtmlBuilder
import Control.Monad.Takahashi.Util

