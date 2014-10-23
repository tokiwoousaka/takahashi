{-# LANGUAGE GADTs, ScopedTypeVariables #-}
module Control.Monad.Takahashi
  ( module Control.Monad.Takahashi.Monad
  , runTaka2Htmls
  , Taka
  , DivOption(..)
  , Color(..)
  , Strength(..)
  , put
  , get
  , writeTakahashi
  ) where
import Control.Monad.Takahashi.Monad
import Control.Monad.Takahashi.Html

import Data.List
import Data.Monoid
import Control.Monad.Operational.Simple
import Control.Monad.RWS

----
--to html

type Taka a = Takahashi DivOption a
type Taka2HtmlRWS a = RWS () [String] DivOption a

taka2Htmls :: Taka a -> Taka2HtmlRWS a
taka2Htmls t = interpret advent t
  where
    advent :: TakahashiBase DivOption x -> Taka2HtmlRWS x
    advent (TakaTitle s m) = tellHtml $ H1 s Emp <> Str m Emp
    advent (Takahashi s) = tellHtml $ H2 s Emp
    advent (TakaSlide s xs) = tellHtml $ H3 s Emp <> Li xs Emp
    advent GetOption = get 
    advent (PutOption o) = put o

    tellHtml :: Html -> Taka2HtmlRWS ()
    tellHtml h = do
      opt <- get
      tell [createSlide opt h]

runTaka2Htmls :: Taka a -> [String]
runTaka2Htmls t = snd $ execRWS (taka2Htmls t) () defaultDivOption

writeTakahashi :: String -> String -> Taka a -> IO ()
writeTakahashi r w t = let
  html = showStrList $ runTaka2Htmls t
  in do
    instr <- readFile r 
    return (sub "##Presentation" html instr) >>= writeFile w

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
