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
  , makeTitleStyle
  , makeContentsStyle
  , makeContentsStyle2
  , makeAnnotationStyle
  , makeCodeStyle
  ----
  , contents
  , central
  ----
  , Contents(..)
  , bindPage
  ) where
import Control.Lens
import Control.Monad.RWS
import Data.List
--import Paths_takahashi TODO

import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.HtmlBuilder
import Control.Monad.Takahashi.Util
import Control.Monad.Operational

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
makeSlide t = undefined --getDataFileName "html/Temp.html" >>= flip makeSlideWithTemplate t TODO

writeSlideWithTemplate :: String -> String -> Taka a -> IO ()
writeSlideWithTemplate r w = makeSlideWithTemplate r >=> writeFile w

writeSlide :: String -> Taka a -> IO ()
writeSlide w = makeSlide >=> writeFile w

------
-- helper 

makeTitleStyle :: SlideOption -> MakeStyle ()
makeTitleStyle = makeBlockStyle titleOption

makeContentsStyle :: SlideOption -> MakeStyle ()
makeContentsStyle = makeBlockStyle contentsOption

makeContentsStyle2 :: SlideOption -> MakeStyle ()
makeContentsStyle2 = makeBlockStyle contentsOption2

makeAnnotationStyle :: SlideOption -> MakeStyle ()
makeAnnotationStyle = makeBlockStyle annotationOption

makeCodeStyle :: SlideOption -> MakeStyle ()
makeCodeStyle o = do
  makeBlockStyle codeOption o
  align.verticalAlign .= Just AlignMiddle
  font.fontFamily .= Just 
    [ FontName "Consolas"
    , FontName "Liberation Mono"
    , FontName "Menlo"
    , FontName "Courier"
    , Monospace
    ]
  font.whiteSpace .= Just Pre

makeBlockStyle :: Getter SlideOption BlockOption -> SlideOption -> MakeStyle ()
makeBlockStyle getter option = do
  border.borderStyle .= Just BorderSolid
  border.boxSizing .= Just BorderBox
  border.borderWidth .= Just 10

  border.borderColor .= option^.getter.frameColor
  font.foreColor .= option^.getter.fontColor
  font.fontSize .= option^.getter.blockFontSize
  border.borderStyle .= option^.getter.frameStyle
  backGround .= option^.getter.bgColor

----

contents :: MakeStyle () -> HBuilder () -> HBuilder ()
contents mStyle f = let
  innerDiv = do
      verticalDiv
        [ divInfo
          { divMakeStyle = do
              mStyle
              display .= Just TableCell
          , divData = f
          }
        ]
  in do
    verticalDiv
      [ divInfo
        { divMakeStyle = do
            display .= Just Table
        , divData = innerDiv
        }
      ]

central :: MakeStyle () -> HBuilder () -> HBuilder ()
central mStyle f = let
  newStyle = do
    mStyle
    align.textAlign .= Just AlignCenter
    align.verticalAlign .= Just AlignMiddle
  in contents newStyle f

----

newtype Contents = Contents { extructHBuilder :: SlideOption -> HBuilder () }

bindPage :: Contents -> Taka ()
bindPage p = do
  o <- get
  slide . extructHBuilder p $ o
