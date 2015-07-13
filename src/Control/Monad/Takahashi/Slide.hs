{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs #-}
module Control.Monad.Takahashi.Slide 
  ( BlockOption(..)
  , fontColor, bgColor, frameColor, frameStyle
  , SlideOption(..)
  , slideTitle, slideFontSize, titleOption, codeOption
  , contentsOption, contentsOption2, annotationOption, blockFontSize
  , defaultSlideOption
  ----
  , Taka(..) 
  , buildTakahashi
  , writeSlideWithTemplate
  , writeSlide
  ----
  , runTakahashi
  , showTakahashi
  , makeSlideWithTemplate
  , makeSlide 
  ) where
import Control.Lens
import Control.Monad.RWS
import Data.List
import Control.Monad.Skeleton
import Paths_takahashi 

import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.HtmlBuilder
import Control.Monad.Takahashi.Util

type TakahashiRWS a = RWS () Html SlideOption a

----

buildTakahashi :: Taka a -> TakahashiRWS a
buildTakahashi t = interpret advent t
  where
    advent :: TakahashiBase a -> TakahashiRWS a
    advent GetSlideOption = get
    advent (PutSlideOption o) = put o
    advent (Slide t) = do
      style <- mkStyle
      tell $ Div Nothing (Just "pages") (Just style) (runBuildHtml t) Emp

    mkStyle :: TakahashiRWS Style
    mkStyle = do
      option <- get
      return . execMakeStyle defaultStyle $ do
        font.fontSize .= option^.slideFontSize

----

runTakahashi :: Taka a -> Html
runTakahashi t = snd $ execRWS (buildTakahashi t) () defaultSlideOption

showTakahashi :: Taka a -> String
showTakahashi = showHtml . runTakahashi

makeSlideWithTemplate :: String -> Taka a -> IO String
makeSlideWithTemplate r t = do
  instr <- readFile r
  return $ sub "##Presentation" (showTakahashi t) instr

makeSlide :: Taka a -> IO String
makeSlide t = getDataFileName "html/Temp.html" >>= flip makeSlideWithTemplate t 

writeSlideWithTemplate :: String -> String -> Taka a -> IO ()
writeSlideWithTemplate r w = makeSlideWithTemplate r >=> writeFile w

writeSlide :: String -> Taka a -> IO ()
writeSlide w = makeSlide >=> writeFile w
