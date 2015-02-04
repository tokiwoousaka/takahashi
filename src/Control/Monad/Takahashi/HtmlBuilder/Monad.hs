{-# LANGUAGE GADTs, DeriveFunctor #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Control.Monad.Takahashi.HtmlBuilder.Monad where
import Control.Monad.Operational.Simple
import Control.Monad.State.Class(MonadState(..))

data DrawType

data DivInfo o = DivInfo 
  { divRatio :: Int
  , divData :: HtmlBuilder o ()
  }

data HtmlBuilderBase o a where
  GetOption :: HtmlBuilderBase o o
  PutOption :: o -> HtmlBuilderBase o ()
  WriteHeader1 :: String -> HtmlBuilderBase o ()
  WriteHeader2 :: String -> HtmlBuilderBase o ()
  WriteHeader3 :: String -> HtmlBuilderBase o ()
  WriteParagraph :: [String] -> HtmlBuilderBase o ()
  WriteList :: [String] -> HtmlBuilderBase o ()
  DrawPicture :: DrawType -> String -> HtmlBuilderBase o ()
  VerticalDiv :: [DivInfo o] -> HtmlBuilderBase o ()
  HorizonDiv :: [DivInfo o] -> HtmlBuilderBase o ()

type HtmlBuilder o = Program (HtmlBuilderBase o)

instance MonadState x (HtmlBuilder x) where
  put = putOption
  get = getOption

----

divInfo2Tuple :: DivInfo o -> (Int, HtmlBuilder o ())
divInfo2Tuple di = (divRatio di, divData di)

tuple2DivInfo :: (Int, HtmlBuilder o ()) -> DivInfo o
tuple2DivInfo (x, y) = DivInfo { divRatio = x, divData = y }

----

getOption :: HtmlBuilder o o
getOption = singleton GetOption

putOption :: o -> HtmlBuilder o ()
putOption v = singleton $ PutOption v

writeHeader1 :: String -> HtmlBuilder o ()
writeHeader1 s = singleton $ WriteHeader1 s

writeHeader2 :: String -> HtmlBuilder o ()
writeHeader2 s = singleton $ WriteHeader2 s

writeHeader3 :: String -> HtmlBuilder o ()
writeHeader3 s = singleton $ WriteHeader3 s

writeParagraph :: [String] -> HtmlBuilder o ()
writeParagraph ss = singleton $ WriteParagraph ss

writeList :: [String] -> HtmlBuilder o ()
writeList ss = singleton $ WriteList ss

drawPicture :: DrawType -> String -> HtmlBuilder o ()
drawPicture t fp = singleton $ DrawPicture t fp

verticalDiv :: [DivInfo o] -> HtmlBuilder o ()
verticalDiv xs = singleton $ VerticalDiv xs

horizonDiv :: [DivInfo o] -> HtmlBuilder o ()
horizonDiv xs = singleton $ HorizonDiv xs

