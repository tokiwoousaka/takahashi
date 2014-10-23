{-# LANGUAGE GADTs, DeriveFunctor #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Control.Monad.Takahashi.Monad where
import Control.Monad.Operational.Simple
import Control.Monad.State.Class(MonadState(..))

data TakahashiBase o a where
  TakaTitle :: String -> String -> TakahashiBase o ()
  Takahashi :: String -> TakahashiBase o ()
  TakaSlide :: String -> [String] -> TakahashiBase o ()
  GetOption :: TakahashiBase o o
  PutOption :: o -> TakahashiBase o ()

type Takahashi b = Program (TakahashiBase b)

instance MonadState x (Takahashi x) where
  put = putOption
  get = getOption

----

title :: String -> String -> Takahashi o ()
title s m = singleton $ TakaTitle s m

taka :: String -> Takahashi o ()
taka s = singleton $ Takahashi s

slide :: String -> [String] -> Takahashi o ()
slide t s = singleton $ TakaSlide t s 

getOption :: Takahashi o o
getOption = singleton GetOption

putOption :: o -> Takahashi o ()
putOption v = singleton $ PutOption v
