{-# LANGUAGE GADTs, ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi where
import Control.Lens
import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.Html

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
defaultSlideOption = undefined

----
--to html

type Taka a = Takahashi SlideOption a
type Taka2HtmlRWS a = RWS () String SlideOption a
data DivDirection = DivVertical | DivHorizon deriving (Show, Read, Eq, Ord)

taka2Htmls :: Taka a -> Taka2HtmlRWS a
taka2Htmls t = interpret advent t
  where
    advent :: TakahashiBase SlideOption x -> Taka2HtmlRWS x
    advent GetOption = get
    advent (PutOption o) = put o
    advent (WriteHeader1 str) = tell . showHtml $ H1 str
    advent (WriteHeader2 str) = tell . showHtml $ H2 str
    advent (WriteHeader3 str) = tell . showHtml $ H3 str
    advent (WriteParagraph xs) = tell . concatMap (showHtml . Str) $ xs
    advent (WriteList xs) = tell . showHtml $ Li xs
    advent (DrawPicture t fp) = tell . showHtml $ Img fp
    advent (VerticalDiv xs) = tell . showHtml $ Div Nothing Nothing Nothing []
    advent (HorizonDiv xs) = tell . showHtml $ Div Nothing Nothing Nothing []

makeDivs :: DivDirection -> [DivInfo o] -> Taka2HtmlRWS ()
makeDivs dir xs = mapM_ tellMakeDiv xs
  where
    tellMakeDiv :: DivInfo o -> Taka2HtmlRWS ()
    tellMakeDiv (DivInfo raito dat) = do
      tmp <- use divStyle
      setStyle raito
      writeStyle <- use divStyle
      tell . showHtml $ Div Nothing Nothing Nothing $ undefined --taka2Htmls dat
      divStyle .= tmp

    setStyle :: Int -> Taka2HtmlRWS ()
    setStyle raito = do
      case dir of
        DivVertical -> do
          divStyle.size .= Size { _height = Just $ Per 100, _width = Just $ Per 100 }
          divStyle.float .= Just FloatLeft
        DivHorizon -> do
          divStyle.size .= Size { _height = Just $ Per 100, _width = Just $ Per 100 }

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

separatePercentage :: RealFrac a => [(a, b)] -> [(Int, b)]
separatePercentage xs = let 
  fstlst = map fst xs 
  sumlst = repeat $ sum fstlst
  perlst = zipWith (/) fstlst sumlst 
  in zip (map (floor . (*100)) perlst) $ map snd xs
