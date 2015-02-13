{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module Control.Monad.Takahashi.Monad where
import Control.Monad.Operational
import Control.Monad.State.Class(MonadState(..))

import Control.Monad.Takahashi.HtmlBuilder

data TakahashiBase o a where
  GetSlideOption :: TakahashiBase o o
  PutSlideOption :: o -> TakahashiBase o ()
  Slide :: HtmlBuilder Style () -> TakahashiBase o ()

type Takahashi o = Program (TakahashiBase o)

instance MonadState x (Takahashi x) where
  put = putSlideOption
  get = getSlideOption

----

getSlideOption :: Takahashi o o
getSlideOption = singleton GetSlideOption

putSlideOption :: o -> Takahashi o ()
putSlideOption v = singleton $ PutSlideOption v

slide :: HtmlBuilder Style () -> Takahashi o ()
slide f = singleton $ Slide f

