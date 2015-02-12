{-# LANGUAGE GADTs, ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi 
  ( module Control.Monad.Takahashi.Monad
  , takaCont
  , parCont
  , listCont
  , horizonCont
  , verticalCont
  , annotationCont
  , imgCont
  , codeCont
  , titleCont
  ----
  , title
  , taka
  , par
  , list
  , horizon
  , vertical
  , annotation
  , img
  , code
  ----
  , makePage
  ------
  -- from Control.Monad.Takahashi.Slide
  , BlockOption
  , fontColor, bgColor, frameColor, frameStyle
  , SlideOption
  , slideTitle, slideFontSize, titleOption, codeOption
  , contentsOption, annotationOption, blockFontSize
  , defaultSlideOption
  ----
  , Taka(..) 
  , buildTakahashi
  , writeSlide
  ----
  , runTakahashi
  , showTakahashi
  , makeSlide 
  ----
  , contents
  , central
  ----
  , Contents
  , bindPage
  ------
  -- from Control.Monad.Takahashi.HtmlBuilder
  , DrawType(..)
  ------
  -- from Control.Monad.Takahashi.Util
  , stateSandbox
  ) where
import Control.Lens
import Control.Monad.State

import Control.Monad.Takahashi.Slide
import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.HtmlBuilder
import Control.Monad.Takahashi.Util

----
-- Contents

emptyCont :: Contents
emptyCont = Contents $ \_ -> return ()

takaCont :: String -> Contents
takaCont s = Contents $ 
  \option -> central (makeContentsStyle option) $ writeHeader1 s

listCont :: [String] -> Contents
listCont xs = Contents $ 
  \option -> contents (basicContents option) $ writeList xs

parCont :: String -> Contents
parCont s = Contents $ 
  \option -> contents (basicContents option) $ writeParagraph s

imgCont :: DrawType -> String -> Contents
imgCont dt fp = Contents $
  \option -> central (return ()) $ drawPicture dt fp

codeCont :: String -> Contents
codeCont s = Contents $
  \option -> contents (codeContents option) $ writeParagraph s

----

horizonCont :: [Contents] -> Contents
horizonCont cs = Contents $ 
  \option -> horizonDiv . map (contents2DivInfo option) $ cs

verticalCont :: [Contents] -> Contents
verticalCont cs = Contents $
  \option -> verticalDiv . map (contents2DivInfo option) $ cs
    
annotationCont :: Contents -> String -> Contents
annotationCont p s = Contents $ \option -> do
    verticalDiv
      [ divInfo
          { divRatio = 11
          , divData = do
              display .= Just Table
              extructHBuilder p option
          }
      , divInfo
          { divData = do
              writeParagraph s
          , divMakeStyle = do
              display .= Just Table
              makeAnnotationStyle option
          }
      ]

twinTopCont :: Contents -> Contents -> Contents
twinTopCont c1 c2 = makeTwinCont verticalDiv 2 1 c1 c2

twinBottomCont :: Contents -> Contents -> Contents
twinBottomCont c1 c2 = makeTwinCont verticalDiv 1 2 c1 c2

twinLeftCont :: Contents -> Contents -> Contents
twinLeftCont c1 c2 = makeTwinCont horizonDiv 2 1 c1 c2

twinRightCont :: Contents -> Contents -> Contents
twinRightCont c1 c2 = makeTwinCont horizonDiv 2 1 c1 c2

titleCont :: String -> String -> Contents
titleCont t s = Contents $ 
  \option -> central (makeTitleStyle option) $ do
    writeHeader1 t
    writeParagraph s
  

----

subTitlePage :: String -> Contents -> Contents
subTitlePage s p = Contents $ \option -> do
  verticalDiv
    [ divInfo
      { divRatio = 10 
      , divData = do
          central (return ()) $ writeHeader2 s
      , divMakeStyle = do
          display .= Just Table
          makeTitleStyle option
      }
    , divInfo
      { divRatio = 45 
      , divData = extructHBuilder p option
      , divMakeStyle = display .= Just Table
      }
    ]

----
-- slides

title :: String -> String -> Taka ()
title t s = get >>= slide . extructHBuilder (titleCont t s)

taka :: String -> Taka ()
taka s = makePage $ takaCont s

list :: [String] -> Taka ()
list xs = makePage $ listCont xs

par :: String -> Taka ()
par s = makePage $ parCont s

horizon :: [Contents] -> Taka ()
horizon ps = makePage $ horizonCont ps

vertical :: [Contents] -> Taka ()
vertical ps = makePage $ verticalCont ps

annotation :: Contents -> String -> Taka ()
annotation p s = makePage $ annotationCont p s

img :: DrawType -> String -> Taka ()
img dt s = makePage $ imgCont dt s

code :: String -> String -> Taka ()
code s c = twinBottom (parCont s) (codeCont c)

twinTop :: Contents -> Contents -> Taka ()
twinTop c1 c2 = makePage $ twinTopCont c1 c2

twinBottom :: Contents -> Contents -> Taka ()
twinBottom c1 c2 = makePage $ twinBottomCont c1 c2

twinLeft :: Contents -> Contents -> Taka ()
twinLeft c1 c2 = makePage $ twinLeftCont c1 c2

twinRight :: Contents -> Contents -> Taka ()
twinRight c1 c2 = makePage $ twinRightCont c1 c2

----
-- helper

makePage :: Contents -> Taka ()
makePage p = do
  s <- use slideTitle
  case s of
    "" -> bindPage p
    _  -> bindPage (subTitlePage s p)

----

contents2DivInfo :: SlideOption -> Contents -> DivInfo Style
contents2DivInfo o f = divInfo { divData = extructHBuilder f o }

basicContents :: SlideOption -> MakeStyle ()
basicContents o = do
  makeContentsStyle o
  setPadding

codeContents :: SlideOption -> MakeStyle ()
codeContents o = do
  makeCodeStyle o
  setPadding

setPadding :: MakeStyle ()
setPadding = do
  margin.paddingTop .= Just (Per 3)
  margin.paddingLeft .= Just (Per 8)

makeTwinCont :: ([DivInfo Style] -> HBuilder ()) 
  -> Int -> Int -> Contents -> Contents -> Contents
makeTwinCont builder i1 i2 c1 c2 = Contents $ \option -> do
    builder
      [ divInfo
          { divRatio = i1
          , divData = do
              display .= Just Table
              extructHBuilder c1 option
          }
      , divInfo
          { divRatio = i2
          , divData = do
              display .= Just Table
              extructHBuilder c2 option
          }
      ]
