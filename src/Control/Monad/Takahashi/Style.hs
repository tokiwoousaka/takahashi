{-# LANGUAGE TemplateHaskell, RankNTypes #-}
module Control.Monad.Takahashi.Style where
import Control.Lens
import Control.Monad.State

data FloatOption = FloatLeft | ClearBoth deriving (Show, Read, Eq, Ord)
data Align = AlignLeft | AlignMiddle | AlignCenter deriving (Show, Read, Eq, Ord)
data Display = DisplayTable | DisplayBlock | DisplayNone deriving (Show, Read, Eq, Ord)
data Len = Per Int | Px Int deriving (Show, Read, Eq, Ord)

data Size = Size 
  { _height :: Maybe Len
  , _width :: Maybe Len
  } deriving (Show, Read, Eq, Ord)

data Style = Style
  { _size :: Size
  , _float :: Maybe FloatOption
  , _display :: Maybe Display
  , _fontSize :: Maybe Int
  } deriving (Show, Read, Eq, Ord)

makeLenses ''Size
makeLenses ''Style

showLen :: Len -> String
showLen (Per x) = show x ++ "%"
showLen (Px x) = show x ++ "px"

showStyle :: Style -> String
showStyle style = concat
  [ maybe "" (\y -> "height:" ++ showLen y ++ ";") $ style^.size.height
  , maybe "" (\y -> "width:" ++ showLen y ++ ";") $ style^.size.width
  , showFloat $ _float style
  , showDisplay $ _display style
  , maybe "" (\y -> "font-size:" ++ show y ++ "px;") $ _fontSize style
  ] 
    where
      showFloat x
        = case x of
          Nothing -> ""
          (Just FloatLeft) -> "float:left;"
          (Just ClearBoth) -> "clear:both;"
      showDisplay x
        = case x of
          Nothing -> ""
          (Just DisplayTable) -> "display:table;"
          (Just DisplayBlock) -> "display:block;"
          (Just DisplayNone) -> "display:none;"

--

defaultStyle :: Style
defaultStyle = Style
  { _size = Size
    { _height = Nothing
    , _width = Nothing
    }
  , _float = Nothing
  , _display = Nothing
  , _fontSize = Nothing
  }

type MakeStyle a = State Style a

runMakeStyle :: Style -> MakeStyle a -> (a, Style)
runMakeStyle s f = runState f defaultStyle

execMakeStyle :: Style -> MakeStyle a -> Style
execMakeStyle s f = execState f defaultStyle

makeStyle :: MakeStyle a -> String
makeStyle f = showStyle . execMakeStyle defaultStyle $ f
