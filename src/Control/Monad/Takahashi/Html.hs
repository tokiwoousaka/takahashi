{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.Html where
import Data.Monoid
import Numeric

data Html 
  = H1 String Html
  | H2 String Html
  | H3 String Html
  | Li [String] Html
  | Str String Html
  | Emp
  deriving (Show, Read, Eq, Ord)

instance Monoid Html where
  mempty = Emp
  (H1 s h) `mappend` i = H1 s (h `mappend` i)
  (H2 s h) `mappend` i = H2 s (h `mappend` i)
  (H3 s h) `mappend` i = H3 s (h `mappend` i)
  (Li xs h) `mappend` i = Li xs (h `mappend` i)
  (Str s h) `mappend` i = Str s (h `mappend` i)
  Emp `mappend` i = i


showHtml :: Html -> String
showHtml (H1 s h) = concat ["<h1>", s, "</h1>", showHtml h]
showHtml (H2 s h) = concat ["<h2>", s, "</h2>", showHtml h]
showHtml (H3 s h) = concat ["<h3>", s, "</h3>", showHtml h]
showHtml (Li xs h) = concat ["<ul>", concatMap (\s -> "<li>" ++ s ++ "</li>") xs, "</ul>", showHtml h]
showHtml (Str s h) = concat ["<p>", s, "</p>", showHtml h]
showHtml Emp = ""

----
-- convert

data Color = Color Integer Integer Integer deriving (Show, Read, Eq, Ord)
data Strength = Weak | Middle | Strong deriving (Show, Read, Ord, Eq)

strength2Size :: Strength -> String
strength2Size Weak = "30pt"
strength2Size Middle = "50pt"
strength2Size Strong = "80pt"

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

createSlide :: DivOption -> Html -> String
createSlide (DivOption fc bc st) h = concat 
  [ "<div class='slide' style='color:"
  , showColor fc
  , ";background:"
  , showColor bc
  , ";font-size:"
  , strength2Size st
  , "'>"
  , showHtml h
  , "</div>"]
