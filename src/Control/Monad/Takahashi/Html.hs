{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.Html 
  ( module Control.Monad.Takahashi.Style
  , module Control.Monad.Takahashi.Html 
  ) where
import Control.Monad.Takahashi.Style
import Data.Monoid
import Data.List
import Numeric

data Html 
  = H1 String
  | H2 String
  | H3 String
  | Li [String]
  | Str String
  | TT String
  | Img String
  | Div 
      (Maybe String) -- Class
      (Maybe String) -- Name
      (Maybe Style)  -- Style
      [Html]         -- Contents
  deriving (Show, Read, Eq, Ord)

showHtml :: Html -> String
showHtml (H1 s) = concat ["<h1>", s, "</h1>"]
showHtml (H2 s) = concat ["<h2>", s, "</h2>"]
showHtml (H3 s) = concat ["<h3>", s, "</h3>"]
showHtml (Li xs) = concat ["<ul>", concatMap (\s -> "<li>" ++ s ++ "</li>") xs, "</ul>"]
showHtml (Str s) = concat ["<p>", s, "</p>"]
showHtml (TT s) = concat ["<tt>", s, "</tt>"]
showHtml (Img fp) = concat ["<img src=\"", fp, "\"/>"]
showHtml div@(Div _ _ _ s) = concat ["<div", showDiv div,">", concat . map showHtml $ s, "</div>"]

showDiv :: Html -> String
showDiv (Div cls name style _) = intercalate " " [classStr, nameStr, styleStr]
  where
    classStr = maybe "" (\x -> "class=\"" ++ x ++ "\"") cls
    nameStr = maybe "" (\x -> "name=\"" ++ x ++ "\"") name
    styleStr = maybe "" (\x -> "style=\"" ++ showStyle x ++ "\"") style
showDiv _ = ""

----
-- convert

data Color = Color Integer Integer Integer deriving (Show, Read, Eq, Ord)
data Strength = Weak | Middle | Strong | FontSize Int deriving (Show, Read, Ord, Eq)

normalizeColor :: Color -> Color
normalizeColor (Color x y z) = Color (normalize x) (normalize y) (normalize z)
  where
    normalize :: Integer -> Integer
    normalize a 
      | a   < 0   = 0
      | 255 < a   = 255
      | otherwise = a

showColor :: Color -> String
showColor (Color x y z) = concat ["#", int2Hex x, int2Hex y, int2Hex z]
  where
    int2Hex :: Integer -> String
    int2Hex i = reverse . take 2 . reverse $ "0" ++ showHex i ""

