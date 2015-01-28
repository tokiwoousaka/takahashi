{-# LANGUAGE GADTs, DeriveFunctor #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Control.Monad.Takahashi.Monad where
import Control.Monad.Operational.Simple
import Control.Monad.State.Class(MonadState(..))

type HeaderLevel = Int
data DrawType

data TakahashiBase o a where
  GetOption :: TakahashiBase o o
  PutOption :: o -> TakahashiBase o ()
  WriteHeader :: HeaderLevel -> String -> TakahashiBase o ()
  WriteParagraph :: [String] -> TakahashiBase o ()
  WriteList :: [String] -> TakahashiBase o ()
  DrawPicture :: DrawType -> TakahashiBase o ()
  VerticalDiv :: [Int] -> TakahashiBase o ()
  HorizonDiv :: [Int] -> TakahashiBase o ()

type Takahashi b = Program (TakahashiBase b)

instance MonadState x (Takahashi x) where
  put = putOption
  get = getOption

----

getOption :: Takahashi o o
getOption = singleton GetOption

putOption :: o -> Takahashi o ()
putOption v = singleton $ PutOption v

writeHeader :: HeaderLevel -> String -> Takahashi o ()
writeHeader h s = singleton $ WriteHeader h s

writeParagraph :: [String] -> Takahashi o ()
writeParagraph ss = singleton $ WriteParagraph ss

writeList :: [String] -> Takahashi o ()
writeList ss = singleton $ WriteList ss

drawPicture :: DrawType -> Takahashi o ()
drawPicture t = singleton $ DrawPicture t

verticalDiv :: [Int] -> Takahashi o ()
verticalDiv xs = singleton $ VerticalDiv xs

horizonDiv :: [Int] -> Takahashi o ()
horizonDiv xs = singleton $ HorizonDiv xs

