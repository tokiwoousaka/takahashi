{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.HtmlBuilder.Html 
  ( Html(..)
  , showHtml
  , showDiv
  ) where
import Control.Monad.Takahashi.HtmlBuilder.Style

import Data.Monoid
import Data.List (intercalate, lines)

data Html 
  = H1 String Html
  | H2 String Html
  | H3 String Html
  | Li [String] Html
  | P String Html
  | TT String Html
  | Img String Style Html
  | Div 
      (Maybe String) -- Class
      (Maybe String) -- Name
      (Maybe Style)  -- Style
      Html           -- Contents
      Html
  | Emp
  deriving (Show, Read, Eq, Ord)

instance Monoid Html where
  mempty = Emp
  (H1 s h) `mappend` i = H1 s (h `mappend` i)
  (H2 s h) `mappend` i = H2 s (h `mappend` i)
  (H3 s h) `mappend` i = H3 s (h `mappend` i)
  (Li xs h) `mappend` i = Li xs (h `mappend` i)
  (P s h) `mappend` i = P s (h `mappend` i)
  (TT s h) `mappend` i = TT s (h `mappend` i)
  (Img fp s h) `mappend` i = Img fp s (h `mappend` i)
  (Div cls name style con h) `mappend` i = Div cls name style con (h `mappend` i)
  Emp `mappend` i = i

----
-- show

showHtml :: Html -> String
showHtml = intercalate "<br />". lines . showHtml'
  where
    showHtml' :: Html -> String
    showHtml' (H1 s h) = concat ["<h1>", s, "</h1>", showHtml h]
    showHtml' (H2 s h) = concat ["<h2>", s, "</h2>", showHtml h]
    showHtml' (H3 s h) = concat ["<h3>", s, "</h3>", showHtml h]
    showHtml' (Li xs h) = concat ["<ul>", concatMap (\s -> "<li>" ++ s ++ "</li>") xs, "</ul>", showHtml h]
    showHtml' (P s h) = concat ["<p>", s, "</p>", showHtml h]
    showHtml' (TT s h) = concat ["<tt>", s, "</tt>", showHtml h]
    showHtml' img@(Img _ _ h) = concat ["<img ", showImg img ,"/>", showHtml h]
    showHtml' div@(Div _ _ _ s h) = concat ["<div ", showDiv div,">", showHtml s, "</div>", showHtml h]
    showHtml' Emp = ""

showDiv :: Html -> String
showDiv (Div cls name style _ _) = intercalate " " $ filter (/="") [classStr, nameStr, styleStr]
  where
    classStr = maybe "" (\x -> "class=\"" ++ x ++ "\"") cls
    nameStr = maybe "" (\x -> "name=\"" ++ x ++ "\"") name
    styleStr = showStyleStr style
showDiv _ = ""

showImg :: Html -> String
showImg (Img fp style _) = intercalate " " $ filter (/="") ["src=\"" ++ fp ++ "\"", styleStr]
  where
    styleStr = showStyleStr $ Just style

showStyleStr :: Maybe Style -> String
showStyleStr style = maybe "" (\x -> "style=\"" ++ showStyle x ++ "\"") style

