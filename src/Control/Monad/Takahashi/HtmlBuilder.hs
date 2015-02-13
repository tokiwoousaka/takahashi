{-# LANGUAGE GADTs, ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.HtmlBuilder 
  ( HBuilder
  , HBuilderRWS
  , DivDirection
  , buildHtml
  , makeDivs
  , runBuildHtml
  , normalizeDivInfo
  , module Control.Monad.Takahashi.HtmlBuilder.Style
  , module Control.Monad.Takahashi.HtmlBuilder.Monad
  , module Control.Monad.Takahashi.HtmlBuilder.Html
  ) where
import Control.Lens
import Control.Monad.Takahashi.HtmlBuilder.Style
import Control.Monad.Takahashi.HtmlBuilder.Monad
import Control.Monad.Takahashi.HtmlBuilder.Html
import Control.Monad.Takahashi.Util

import Data.List
import Data.Monoid
import Control.Monad.Operational
import Control.Monad.RWS

----
--to html

type HBuilder a = HtmlBuilder Style a
type HBuilderRWS a = RWS () Html Style a
data DivDirection = DivVertical | DivHorizon deriving (Show, Read, Eq, Ord)

buildHtml :: HBuilder a -> HBuilderRWS a
buildHtml t = interpret advent t
  where
    advent :: HtmlBuilderBase Style x -> HBuilderRWS x
    advent GetHtmlOption = get
    advent (PutHtmlOption o) = put o
    advent (WriteHeader1 str) = tell $ H1 str Emp
    advent (WriteHeader2 str) = tell $ H2 str Emp
    advent (WriteHeader3 str) = tell $ H3 str Emp
    advent (WriteParagraph s) = tell $ P s Emp
    advent (WriteList xs) = tell $ Li xs Emp
    advent (DrawPicture dt fp) = tell $ Img fp (drawType2Style dt) Emp
    advent (VerticalDiv xs) = makeDivs DivVertical $ normalizeDivInfo xs
    advent (HorizonDiv xs) = do
      makeDivs DivHorizon $ normalizeDivInfo xs
      stateSandbox $ do
        float .= Just ClearBoth
        writeStyle <- get
        tell $ Div Nothing Nothing (Just writeStyle) Emp Emp
    advent (WriteHtml h) = tell h

makeDivs :: DivDirection -> [DivInfo Style] -> HBuilderRWS ()
makeDivs dir xs = mapM_ tellMakeDiv xs
  where
    tellMakeDiv :: DivInfo Style -> HBuilderRWS ()
    tellMakeDiv (DivInfo raito makeStyle dat) = do
      stateSandbox $ do
        setStyle raito
        writeStyle <- get
        tell $ Div (Just "block") Nothing (Just . flip execMakeStyle makeStyle $ writeStyle) (runBuildHtml dat) $ Emp

    setStyle :: Int -> HBuilderRWS ()
    setStyle raito = do
      case dir of
        DivVertical -> do
          size .= Size { _height = Just $ Per raito, _width = Just $ Per 100 }
        DivHorizon -> do
          size .= Size { _height = Just $ Per 100, _width = Just $ Per raito }
          float .= Just FloatLeft

runBuildHtml :: HBuilder a -> Html
runBuildHtml t = snd $ execRWS (buildHtml t) () defaultStyle

----
--helper

normalizeDivInfo :: [DivInfo o] -> [DivInfo o]
normalizeDivInfo = map tuple2DivInfo . separatePercentage . map divInfo2Tuple 

separatePercentage :: [(Int, b)] -> [(Int, b)]
separatePercentage xs = let 
  fstlst = map (fromIntegral . fst) xs 
  sumlst = repeat $ sum fstlst
  perlst = zipWith (/) fstlst sumlst 
  in zip (map (floor . (*100)) perlst) $ map snd xs

drawType2Style :: DrawType -> Style
drawType2Style dt = execMakeStyle defaultStyle (drawType2MakeStyle dt) 
  where
    drawType2MakeStyle :: DrawType -> MakeStyle ()
    drawType2MakeStyle SimpleDraw = return ()
    drawType2MakeStyle HStretch = size.height .= Just (Per 90)
    drawType2MakeStyle WStretch = size.width .= Just (Per 90)
    drawType2MakeStyle Stretch = do
      size.height .= Just (Per 90)
      size.width .= Just (Per 90)
