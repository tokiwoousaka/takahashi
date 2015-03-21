{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}
module Control.Monad.Takahashi.Monad where
import Control.Lens
import Control.Monad.Operational
import Control.Monad.State.Class(MonadState(..))

import Control.Monad.Takahashi.HtmlBuilder

data TakahashiBase a where
  GetSlideOption :: TakahashiBase SlideOption
  PutSlideOption :: SlideOption -> TakahashiBase ()
  Slide :: HtmlBuilder Style () -> TakahashiBase ()

type Taka = Program TakahashiBase

instance MonadState SlideOption Taka where
  put = putSlideOption
  get = getSlideOption

----

getSlideOption :: Taka SlideOption
getSlideOption = singleton GetSlideOption

putSlideOption :: SlideOption -> Taka ()
putSlideOption v = singleton $ PutSlideOption v

slide :: HtmlBuilder Style () -> Taka ()
slide f = singleton $ Slide f

------
-- slide options

data BlockOption = BlockOption
  { _fontColor :: Maybe Color
  , _bgColor :: Maybe Color
  , _frameColor :: Maybe Color
  , _frameStyle :: Maybe BorderStyle
  , _blockFontSize :: Maybe Int
  } deriving (Show, Read, Eq, Ord)

data SlideOption = SlideOption 
  { _slideTitle :: String
  , _slideFontSize :: Maybe Int
  , _titleOption :: BlockOption
  , _contentsOption :: BlockOption
  , _contentsOption2 :: BlockOption
  , _annotationOption :: BlockOption
  , _codeOption :: BlockOption
  } deriving (Show, Read, Eq, Ord)

makeLenses ''BlockOption
makeLenses ''SlideOption

defaultSlideOption :: SlideOption
defaultSlideOption = SlideOption
  { _slideTitle = ""
  , _slideFontSize = Nothing
  , _titleOption = BlockOption
    { _fontColor = Just $ Color 0 0 80
    , _bgColor = Just $ Color 100 100 255
    , _frameColor = Just $ Color 0 0 80
    , _frameStyle = Just BorderSolid
    , _blockFontSize = Nothing
    }
  , _contentsOption = BlockOption
    { _fontColor = Just $ Color 0 0 80
    , _bgColor = Just $ Color 200 200 255
    , _frameColor = Just $ Color 255 255 255
    , _frameStyle = Just BorderSolid
    , _blockFontSize = Nothing
    }
  , _contentsOption2 = BlockOption
    { _fontColor = Just $ Color 80 0 0
    , _bgColor = Just $ Color 255 200 200 
    , _frameColor = Just $ Color 255 255 255
    , _frameStyle = Just BorderSolid
    , _blockFontSize = Nothing
    }
  , _annotationOption = BlockOption
    { _fontColor = Just $ Color 255 0 0
    , _bgColor = Nothing
    , _frameColor = Just $ Color 255 255 255
    , _frameStyle = Nothing
    , _blockFontSize = Nothing
    }
  , _codeOption = BlockOption
    { _fontColor = Just $ Color 0 0 80
    , _bgColor = Nothing
    , _frameColor = Just $ Color 0 0 80
    , _frameStyle = Just BorderDouble
    , _blockFontSize = Nothing
    }
  }
