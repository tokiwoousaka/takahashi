{-# LANGUAGE RankNTypes #-}
module Control.Monad.Takahashi.API 
  ( Contents(..)
  , bindPage
  ----
  , takaCont 
  , listCont 
  , parCont 
  , takaCont2 
  , listCont2 
  , parCont2 
  , imgCont 
  , codeCont 
  , horizonCont 
  , verticalCont 
  , annotationCont 
  , twinTopCont 
  , twinBottomCont 
  , twinLeftCont 
  , twinRightCont 
  , titleCont 
  ----
  , title 
  , taka 
  , list 
  , par 
  , taka2 
  , list2 
  , par2 
  , horizon 
  , vertical 
  , annotation 
  , img 
  , code 
  , code2 
  , twinTop 
  , twinBottom 
  , twinLeft 
  , twinRight 
  ) where
import Control.Monad.State
import Control.Lens

import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.HtmlBuilder
import Control.Monad.Takahashi.Util

----

newtype Contents = Contents { extructHBuilder :: SlideOption -> HBuilder () }

bindPage :: Contents -> Taka ()
bindPage p = do
  o <- get
  slide . extructHBuilder p $ o

----
-- Contents

takaCont :: String -> Contents
takaCont = takaContBase makeContentsStyle

listCont :: [String] -> Contents
listCont = listContBase basicContents

parCont :: String -> Contents
parCont = parContBase basicContents

takaCont2 :: String -> Contents
takaCont2 = takaContBase makeContentsStyle2

listCont2 :: [String] -> Contents
listCont2 = listContBase basicContents2

parCont2 :: String -> Contents
parCont2 = parContBase basicContents2

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

takaContBase :: (SlideOption -> MakeStyle ()) -> String -> Contents
takaContBase m s = Contents $ 
  \option -> central (m option) $ writeHeader1 s

listContBase :: (SlideOption -> MakeStyle ()) -> [String] -> Contents
listContBase m xs = Contents $ 
  \option -> contents (m option) $ writeList xs

parContBase :: (SlideOption -> MakeStyle ()) -> String -> Contents
parContBase m s = Contents $ 
  \option -> contents (m option) $ writeParagraph s

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

taka2 :: String -> Taka ()
taka2 s = makePage $ takaCont2 s

list2 :: [String] -> Taka ()
list2 xs = makePage $ listCont2 xs

par2 :: String -> Taka ()
par2 s = makePage $ parCont2 s

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

code2 :: String -> String -> Taka ()
code2 s c = twinBottom (parCont2 s) (codeCont c)

twinTop :: Contents -> Contents -> Taka ()
twinTop c1 c2 = makePage $ twinTopCont c1 c2

twinBottom :: Contents -> Contents -> Taka ()
twinBottom c1 c2 = makePage $ twinBottomCont c1 c2

twinLeft :: Contents -> Contents -> Taka ()
twinLeft c1 c2 = makePage $ twinLeftCont c1 c2

twinRight :: Contents -> Contents -> Taka ()
twinRight c1 c2 = makePage $ twinRightCont c1 c2



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

basicContents2 :: SlideOption -> MakeStyle ()
basicContents2 o = do
  makeContentsStyle2 o
  setPadding

codeContents :: SlideOption -> MakeStyle ()
codeContents o = do
  makeCodeStyle o
  margin.paddingLeft .= Just (Per 8)

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

