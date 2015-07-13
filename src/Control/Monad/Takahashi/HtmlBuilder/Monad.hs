{-# LANGUAGE GADTs, DeriveFunctor #-}
{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances, UndecidableInstances #-}
module Control.Monad.Takahashi.HtmlBuilder.Monad where
import Control.Monad.Skeleton
import Control.Monad.State.Class(MonadState(..))
import Control.Monad.Takahashi.HtmlBuilder.Style
import Control.Monad.Writer

import Control.Monad.Takahashi.HtmlBuilder.Html

data DrawType = SimpleDraw | HStretch | WStretch | Stretch deriving (Show, Read, Eq, Ord)

data DivInfo o = DivInfo 
  { divRatio :: Int
  , divMakeStyle :: MakeStyle ()
  , divData :: HtmlBuilder o ()
  }

divInfo :: DivInfo o
divInfo = DivInfo
  { divRatio = 1
  , divMakeStyle = return ()
  , divData = return ()
  }

data HtmlBuilderBase o a where
  GetHtmlOption :: HtmlBuilderBase o o
  PutHtmlOption :: o -> HtmlBuilderBase o ()
  WriteHeader1 :: String -> HtmlBuilderBase o ()
  WriteHeader2 :: String -> HtmlBuilderBase o ()
  WriteHeader3 :: String -> HtmlBuilderBase o ()
  WriteParagraph :: String -> HtmlBuilderBase o ()
  WriteList :: [String] -> HtmlBuilderBase o ()
  DrawPicture :: DrawType -> String -> HtmlBuilderBase o ()
  VerticalDiv :: [DivInfo o] -> HtmlBuilderBase o ()
  HorizonDiv :: [DivInfo o] -> HtmlBuilderBase o ()
  WriteHtml :: Html -> HtmlBuilderBase o ()

type HtmlBuilder o = Skeleton (HtmlBuilderBase o) 

instance MonadState x (HtmlBuilder x) where
  put = putHtmlOption
  get = getHtmlOption

----

divInfo2Tuple :: DivInfo o -> (Int, (MakeStyle (), HtmlBuilder o ()))
divInfo2Tuple di = (divRatio di, (divMakeStyle di, divData di))

tuple2DivInfo :: (Int, (MakeStyle (), HtmlBuilder o ())) -> DivInfo o
tuple2DivInfo (x, (y, z)) = DivInfo { divRatio = x, divMakeStyle = y, divData = z }

----

getHtmlOption :: HtmlBuilder o o
getHtmlOption = bone GetHtmlOption

putHtmlOption :: o -> HtmlBuilder o ()
putHtmlOption v = bone $ PutHtmlOption v

writeHeader1 :: String -> HtmlBuilder o ()
writeHeader1 s = bone $ WriteHeader1 s

writeHeader2 :: String -> HtmlBuilder o ()
writeHeader2 s = bone $ WriteHeader2 s

writeHeader3 :: String -> HtmlBuilder o ()
writeHeader3 s = bone $ WriteHeader3 s

writeParagraph :: String -> HtmlBuilder o ()
writeParagraph ss = bone $ WriteParagraph ss

writeList :: [String] -> HtmlBuilder o ()
writeList ss = bone $ WriteList ss

drawPicture :: DrawType -> String -> HtmlBuilder o ()
drawPicture t fp = bone $ DrawPicture t fp

verticalDiv :: [DivInfo o] -> HtmlBuilder o ()
verticalDiv xs = bone $ VerticalDiv xs

horizonDiv :: [DivInfo o] -> HtmlBuilder o ()
horizonDiv xs = bone $ HorizonDiv xs

writeHtml :: Html -> HtmlBuilder o ()
writeHtml h = bone $ WriteHtml h
