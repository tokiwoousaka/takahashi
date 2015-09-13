-- 2015/09以降適用
module Common where
import Control.Monad.Takahashi
import Control.Lens

setOptions :: Taka ()
setOptions = do
  slideFontSize .= Just 60
  -- title
  titleOption.bgColor .= Just (Color 100 100 100)
  titleOption.fontColor .= Just (Color 255 255 255)
  titleOption.frameColor .= Just (Color 150 150 150)
  -- contents
  contentsOption.bgColor .= Nothing
  contentsOption.fontColor .= Just (Color 0 0 0)
  contentsOption.frameColor .= Just (Color 255 255 255)
  -- contents2
  contentsOption2.bgColor .= Just (Color 200 200 200)
  contentsOption2.fontColor .= Just (Color 0 0 0)
  contentsOption2.frameColor .= Just (Color 255 255 255)
  -- code
  codeOption.fontColor .= Just (Color 0 0 0)
  codeOption.frameColor .= Just (Color 0 0 0)
  codeOption.blockFontSize .= Just 40


-- 見出しページ付与
header :: String -> Taka () -> Taka ()
header s t = do
  stateSandbox $ do
    slideTitle .= ""
    slideFontSize .= Just 60
    taka2 s
  t

big :: String -> Taka () 
big s = do
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 80
    par s

bigList :: [String] -> Taka () 
bigList ss = do
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 80
    list ss
