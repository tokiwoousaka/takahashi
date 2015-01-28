{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.Style where
import Control.Lens
import Control.Monad.State

data FloatOption = FloatLeft | ClearBoth deriving (Show, Read, Eq, Ord)
data Align = AlignLeft | AlignMiddle | AlignCenter deriving (Show, Read, Eq, Ord)
data Display = DisplayTable | DisplayBlock | DisplayNone deriving (Show, Read, Eq, Ord)

data Style = Style
  { _styleHeight :: Maybe Int
  , _styleWidth :: Maybe Int
  , _styleFloat :: Maybe FloatOption
  , _styleDisplay :: Maybe Display
  , _styleFontSize :: Maybe Int
  } deriving (Show, Read, Eq, Ord)

makeLenses ''Style

showStyle :: Style -> String
showStyle style = concat
  [ maybe "" (\y -> "height:" ++ show y ++ ";") $ _styleHeight style
  , maybe "" (\y -> "width:" ++ show  y ++ ";") $ _styleWidth style
  , showFloat $ _styleFloat style
  , showDisplay $ _styleDisplay style
  , maybe "" (\y -> "font-size:" ++ show y ++ "px;") $ _styleFontSize style
  ] 
    where
      showFloat x
        = case x of
          Nothing -> ""
          (Just FloatLeft) -> "float:left;"
          (Just ClearBoth) -> "clear:both;"
      showDisplay x
        = "display:" ++ case x of
          (Just DisplayTable) -> "table;"
          (Just DisplayBlock) -> "block;"
          (Just DisplayNone) -> "none;"

----

defaultStyle :: Style
defaultStyle = Style
  { _styleHeight = Nothing
  , _styleWidth = Nothing
  , _styleFloat = Nothing
  , _styleDisplay = Nothing
  , _styleFontSize = Nothing
  }

type MakeStyle a = State Style a

runMakeStyle :: MakeStyle a -> (a, Style)
runMakeStyle f = runState f defaultStyle

execMakeStyle :: MakeStyle a -> Style
execMakeStyle f = execState f defaultStyle
