{-# LANGUAGE TemplateHaskell, RankNTypes #-}
module Control.Monad.Takahashi.HtmlBuilder.Style 
  ( FloatOption(..)
  , TextAlign(..)
  , VerticalAlign(..)
  , Display(..)
  , Len(..)
  , Color(..)
  , BorderStyle(..)
  , BoxSizing(..)
  , FontFamily(..)
  , WhiteSpace(..)
  -----
  , Style(..)
  , size, float, display, font, backGround, align, border
  , Size(..)
  , height, width
  , Align(..)
  , textAlign, verticalAlign
  , Font(..)
  , foreColor, fontSize, fontFamily, whiteSpace
  , Margin(..)
  , margin, paddingTop, paddingLeft, paddingRight, paddingBottom
  , marginTop, marginLeft, marginRight, marginBottom
  , Border(..)
  , borderColor, borderWidth, borderStyle, boxSizing 
  -----
  , defaultStyle
  , MakeStyle
  , runMakeStyle
  , execMakeStyle
  , showStyle
  , makeStyle
  -----
  , normalizeColor
  , showColor
  ) where
import Control.Lens
import Control.Monad.State
import Numeric
import Data.List(intercalate)

data FloatOption = FloatLeft | ClearBoth deriving (Show, Read, Eq, Ord)
data TextAlign = AlignLeft | AlignCenter | AlignRight deriving (Show, Read, Eq, Ord)
data VerticalAlign = AlignTop | AlignMiddle | AlignBottom deriving (Show, Read, Eq, Ord)
data Display = Table | TableCell | Block | None | InlineTable | InlineBlock deriving (Show, Read, Eq, Ord)
data Len = Per Int | Px Int deriving (Show, Read, Eq, Ord)
data Color = Color Integer Integer Integer deriving (Show, Read, Eq, Ord)
data BorderStyle = BorderNone | BorderSolid | BorderDouble deriving (Show, Read, Eq, Ord)
data BoxSizing = ContentsBox | BorderBox  deriving (Show, Read, Eq, Ord)
data FontFamily = FontName String | Monospace | Selif | SensSelif deriving (Show, Read, Eq, Ord)
data WhiteSpace = Normal | Pre deriving (Show, Read, Eq, Ord)

data Margin = Margin 
  { _paddingTop :: Maybe Len
  , _paddingLeft :: Maybe Len
  , _paddingBottom :: Maybe Len
  , _paddingRight :: Maybe Len
  , _marginTop :: Maybe Len
  , _marginLeft :: Maybe Len
  , _marginBottom :: Maybe Len
  , _marginRight :: Maybe Len
  } deriving (Show, Read, Eq, Ord)

data Size = Size 
  { _height :: Maybe Len
  , _width :: Maybe Len
  } deriving (Show, Read, Eq, Ord)

data Align = Align
  { _textAlign :: Maybe TextAlign
  , _verticalAlign :: Maybe VerticalAlign
  } deriving (Show, Read, Eq, Ord)

data Font = Font
  { _foreColor :: Maybe Color
  , _fontSize :: Maybe Int
  , _fontFamily :: Maybe [FontFamily]
  , _whiteSpace :: Maybe WhiteSpace
  } deriving (Show, Read, Eq, Ord)

data Border = Border 
  { _borderColor :: Maybe Color
  , _borderWidth :: Maybe Int
  , _borderStyle :: Maybe BorderStyle
  , _boxSizing :: Maybe BoxSizing
  } deriving (Show, Read, Eq, Ord)

data Style = Style
  { _size :: Size
  , _float :: Maybe FloatOption
  , _display :: Maybe Display
  , _backGround :: Maybe Color
  , _margin :: Margin
  , _border :: Border
  , _font :: Font
  , _align :: Align
  } deriving (Show, Read, Eq, Ord)

makeLenses ''Margin
makeLenses ''Size
makeLenses ''Align
makeLenses ''Font
makeLenses ''Style
makeLenses ''Border

defaultStyle :: Style
defaultStyle = Style
  { _size = Size
    { _height = Nothing
    , _width = Nothing
    }
  , _align = Align
    { _textAlign = Nothing
    , _verticalAlign = Nothing
    }
  , _font = Font
    { _fontSize = Nothing
    , _foreColor = Nothing
    , _fontFamily = Nothing
    , _whiteSpace = Nothing
    }
  , _margin = Margin
    { _paddingTop = Nothing
    , _paddingLeft = Nothing
    , _paddingBottom  = Nothing
    , _paddingRight  = Nothing
    , _marginTop = Nothing
    , _marginLeft = Nothing
    , _marginBottom  = Nothing
    , _marginRight  = Nothing
    }
  , _border = Border
    { _borderColor = Nothing
    , _borderWidth = Nothing
    , _borderStyle = Nothing
    , _boxSizing = Nothing
    }
  , _float = Nothing
  , _display = Nothing
  , _backGround = Nothing
  }

----

showStyle :: Style -> String
showStyle style = intercalate ";" . filter (/="") $
  [ emaybe (\y -> "height:" ++ showLen y) $ style^.size.height
  , emaybe (\y -> "width:" ++ showLen y) $ style^.size.width
  , emaybe (\y -> "text-align:" ++ showTextAlign y) $ style^.align.textAlign
  , emaybe (\y -> "vertical-align:" ++ showVerticalAlign y) $ style^.align.verticalAlign
  , emaybe showFloat $ _float style
  , emaybe (\y -> "display:" ++ showDisplay y) $ _display style
  , emaybe (\y -> "font-size:" ++ show y ++ "px") $ style^.font.fontSize
  , emaybe (\y -> "color:" ++ showColor y) $ style^.font.foreColor
  , emaybe (\y -> "background:" ++ showColor y) $ _backGround style
  , emaybe (\y -> "padding-top:" ++ showLen y) $ style^.margin.paddingTop
  , emaybe (\y -> "padding-left:" ++ showLen y) $ style^.margin.paddingLeft
  , emaybe (\y -> "padding-right:" ++ showLen y) $ style^.margin.paddingRight
  , emaybe (\y -> "padding-bottom:" ++ showLen y) $ style^.margin.paddingBottom
  , emaybe (\y -> "margin-top:" ++ showLen y) $ style^.margin.marginTop
  , emaybe (\y -> "margin-left:" ++ showLen y) $ style^.margin.marginLeft
  , emaybe (\y -> "margin-right:" ++ showLen y) $ style^.margin.marginRight
  , emaybe (\y -> "margin-bottom:" ++ showLen y) $ style^.margin.marginBottom
  , emaybe (\y -> "border-width:" ++ show y) $ style^.border.borderWidth
  , emaybe (\y -> "border-style:" ++ showBorderStyle y) $ style^.border.borderStyle
  , emaybe (\y -> "border-color:" ++ showColor y) $ style^.border.borderColor
  , emaybe (\y -> "box-sizing:" ++ showBoxSizing y) $ style^.border.boxSizing
  , emaybe (\y -> "font-family:" ++ (intercalate "," $ map showFontFamily y)) $ style^.font.fontFamily
  , emaybe (\y -> "white-space:" ++ showWhiteSpace y) $ style^.font.whiteSpace
  ] 
    where
      emaybe = maybe ""     

      showFloat x
        = case x of
          FloatLeft -> "float:left"
          ClearBoth -> "clear:both"

      showDisplay x
        = case x of
          Table -> "table"
          Block -> "block"
          TableCell -> "table-cell"
          None -> "none;"
          InlineTable -> "inline-table"
          InlineBlock -> "inline-block"

      showBorderStyle x
        = case x of
          BorderNone -> "none"
          BorderSolid -> "solid"
          BorderDouble -> "double"

      showBoxSizing x
        = case x of
          ContentsBox -> "contents-box"
          BorderBox -> "border-box"

      showFontFamily x
        = case x of
          FontName s -> "'" ++ s ++ "'"
          Monospace -> "monospace"
          Selif -> "selif"
          SensSelif -> "sens-selif"

      showWhiteSpace x
        = case x of
          Normal -> "normal"
          Pre -> "pre"

showLen :: Len -> String
showLen (Per x) = show x ++ "%"
showLen (Px x) = show x ++ "px"

----

type MakeStyle a = State Style a

runMakeStyle :: Style -> MakeStyle a -> (a, Style)
runMakeStyle s f = runState f s

execMakeStyle :: Style -> MakeStyle a -> Style
execMakeStyle s f = execState f s

makeStyle :: MakeStyle a -> String
makeStyle f = showStyle . execMakeStyle defaultStyle $ f

----

showTextAlign :: TextAlign -> String
showTextAlign AlignLeft = "left"
showTextAlign AlignCenter = "center"
showTextAlign AlignRight = "right"

showVerticalAlign :: VerticalAlign -> String
showVerticalAlign AlignTop = "top"
showVerticalAlign AlignMiddle = "middle"
showVerticalAlign AlignBottom = "bottom"

----

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

