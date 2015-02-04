{-# LANGUAGE GADTs, ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.HtmlBuilder  
  ( module Control.Monad.Takahashi.HtmlBuilder.Monad
  , module Control.Monad.Takahashi.HtmlBuilder.Html
  , HBuilder(..)
  , runBuildHtml
  ) where
import Control.Lens
import Control.Monad.Takahashi.HtmlBuilder.Monad
import Control.Monad.Takahashi.HtmlBuilder.Html

import Data.List
import Data.Monoid
import Control.Monad.Operational.Simple
import Control.Monad.RWS

----
--option

data SlideOption = SlideOption
  { _divStyle :: Style
  , _slideStyle :: Style
  } deriving (Show, Read, Eq)

makeLenses ''SlideOption

defaultSlideOption :: SlideOption
defaultSlideOption = SlideOption
  { _divStyle = defaultStyle
  , _slideStyle = defaultStyle
  }

----
--to html

type HBuilder a = HtmlBuilder SlideOption a
type Taka2HtmlRWS a = RWS () Html SlideOption a
data DivDirection = DivVertical | DivHorizon deriving (Show, Read, Eq, Ord)

buildHtml :: HBuilder a -> Taka2HtmlRWS a
buildHtml t = interpret advent t
  where
    advent :: HtmlBuilderBase SlideOption x -> Taka2HtmlRWS x
    advent GetOption = get
    advent (PutOption o) = put o
    advent (WriteHeader1 str) = tell $ H1 str Emp
    advent (WriteHeader2 str) = tell $ H2 str Emp
    advent (WriteHeader3 str) = tell $ H3 str Emp
    advent (WriteParagraph xs) = tell $ P xs Emp
    advent (WriteList xs) = tell $ Li xs Emp
    advent (DrawPicture t fp) = tell $ Img fp Emp
    advent (VerticalDiv xs) = makeDivs DivVertical $ normalizeDivInfo xs
    advent (HorizonDiv xs) = do
      makeDivs DivHorizon $ normalizeDivInfo xs
      stateSandbox $ do
        divStyle.float .= Just ClearBoth
        tell $ Div Nothing Nothing Nothing Emp Emp

makeDivs :: DivDirection -> [DivInfo SlideOption] -> Taka2HtmlRWS ()
makeDivs dir xs = mapM_ tellMakeDiv xs
  where
    tellMakeDiv :: DivInfo SlideOption -> Taka2HtmlRWS ()
    tellMakeDiv (DivInfo raito dat) = do
      stateSandbox $ do
        setStyle raito
        writeStyle <- use divStyle
        tell $ Div Nothing Nothing (Just writeStyle) (runBuildHtml dat) $ Emp

    setStyle :: Int -> Taka2HtmlRWS ()
    setStyle raito = do
      case dir of
        DivVertical -> do
          divStyle.size .= Size { _height = Just $ Per raito, _width = Just $ Per 100 }
          divStyle.float .= Just FloatLeft
        DivHorizon -> do
          divStyle.size .= Size { _height = Just $ Per 100, _width = Just $ Per raito }

runBuildHtml :: HBuilder a -> Html
runBuildHtml t = snd $ execRWS (buildHtml t) () defaultSlideOption

----
--helper

showStrList :: [String] -> String
showStrList xs = let
  htmls = map (\s -> "\"" ++ s ++ "\"") xs
  in "[" ++ intercalate "," htmls ++ "]"

-- from : http://d.hatena.ne.jp/bsq77/20130224/1361672367
sub :: Eq a => [a] -> [a] -> [a] -> [a]
sub _ _ [] = []
sub x y str@(s:ss)
  | isPrefixOf x str = y ++ drop (length x) str
  | otherwise = s:sub x y ss

normalizeDivInfo :: [DivInfo o] -> [DivInfo o]
normalizeDivInfo = map tuple2DivInfo . separatePercentage . map divInfo2Tuple 

separatePercentage :: [(Int, b)] -> [(Int, b)]
separatePercentage xs = let 
  fstlst = map (fromIntegral . fst) xs 
  sumlst = repeat $ sum fstlst
  perlst = zipWith (/) fstlst sumlst 
  in zip (map (floor . (*100)) perlst) $ map snd xs

stateSandbox :: MonadState s m => m a -> m a
stateSandbox f = do
  tmp <- get 
  res <- f
  put tmp
  return res
