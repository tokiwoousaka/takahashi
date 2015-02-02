{-# LANGUAGE GADTs, DeriveFunctor #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Control.Monad.Takahashi.Monad where
import Control.Monad.Operational.Simple
import Control.Monad.State.Class(MonadState(..))

data DrawType

data DivInfo o = DivInfo 
  { divRatio :: Int
  , divData :: Takahashi o ()
  }

data TakahashiBase o a where
  GetOption :: TakahashiBase o o
  PutOption :: o -> TakahashiBase o ()
  WriteHeader1 :: String -> TakahashiBase o ()
  WriteHeader2 :: String -> TakahashiBase o ()
  WriteHeader3 :: String -> TakahashiBase o ()
  WriteParagraph :: [String] -> TakahashiBase o ()
  WriteList :: [String] -> TakahashiBase o ()
  DrawPicture :: DrawType -> String -> TakahashiBase o ()
  VerticalDiv :: [DivInfo o] -> TakahashiBase o ()
  HorizonDiv :: [DivInfo o] -> TakahashiBase o ()

type Takahashi o = Program (TakahashiBase o)

instance MonadState x (Takahashi x) where
  put = putOption
  get = getOption

----

getOption :: Takahashi o o
getOption = singleton GetOption

putOption :: o -> Takahashi o ()
putOption v = singleton $ PutOption v

writeHeader1 :: String -> Takahashi o ()
writeHeader1 s = singleton $ WriteHeader1 s

writeHeader2 :: String -> Takahashi o ()
writeHeader2 s = singleton $ WriteHeader2 s

writeHeader3 :: String -> Takahashi o ()
writeHeader3 s = singleton $ WriteHeader3 s

writeParagraph :: [String] -> Takahashi o ()
writeParagraph ss = singleton $ WriteParagraph ss

writeList :: [String] -> Takahashi o ()
writeList ss = singleton $ WriteList ss

drawPicture :: DrawType -> String -> Takahashi o ()
drawPicture t fp = singleton $ DrawPicture t fp

verticalDiv :: [DivInfo o] -> Takahashi o ()
verticalDiv xs = singleton $ VerticalDiv xs

horizonDiv :: [DivInfo o] -> Takahashi o ()
horizonDiv xs = singleton $ HorizonDiv xs

