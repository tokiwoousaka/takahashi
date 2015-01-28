{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.Html where
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
  | Div 
      (Maybe String) -- Class
      (Maybe String) -- Name
      (Maybe Style)  -- Style
      [Html]         -- Contents
  deriving (Show, Read, Eq, Ord)

showHtml :: [Html] -> String
showHtml [] = ""
showHtml (H1 s : xs) = concat ["<h1>", s, "</h1>", showHtml xs]
showHtml (H2 s : xs) = concat ["<h2>", s, "</h2>", showHtml xs]
showHtml (H3 s : xs) = concat ["<h3>", s, "</h3>", showHtml xs]
showHtml (Li xs : ys) = concat ["<ul>", concatMap (\s -> "<li>" ++ s ++ "</li>") xs, "</ul>", showHtml ys]
showHtml (Str s : xs) = concat ["<p>", s, "</p>", showHtml xs]
showHtml (TT s : xs) = concat ["<tt>", s, "</tt>", showHtml xs]
showHtml (div@(Div _ _ _ s) : xs) = concat ["<div", showDiv div,">", showHtml s, "</div>", showHtml xs]

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

--strength2Size :: Strength -> String
--strength2Size Weak = "30pt"
--strength2Size Middle = "50pt"
--strength2Size Strong = "80pt"

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

data DivOption = DivOption
  { divForeColor :: Color
  , divBackColor :: Color
  , divStrength :: Strength
  } deriving (Show, Read, Eq, Ord)

defaultDivOption :: DivOption
defaultDivOption = DivOption
  { divForeColor = Color 0 0 0
  , divBackColor = Color 255 255 255
  , divStrength = Middle
  }

