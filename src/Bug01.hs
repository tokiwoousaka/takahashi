module Main where
import Control.Monad.Takahashi
import Control.Lens
import Control.Monad.State

main :: IO ()
main = do
  writeSlide "../contents/Bug01.html" presentation
  putStrLn "Sucess."

presentation :: Taka ()
presentation = do
  slideTitle .= "ほげほげ"
  stateSandbox $ do
  twinLeft
    ( listCont
      [ "ぴよぴよ"
      ]
    )
    ( verticalCont
      [ imgCont HStretch "../img/my_icon.gif"
      , parCont2
        $  "ふがふが"
      ]
    )
  twinLeft
    ( listCont
      [ "ぴよぴよ"
      ]
    )
    ( verticalCont
      [ imgCont WStretch "../img/my_icon2.gif"
      , parCont2
        $  "ふがふが"
      ]
    )
