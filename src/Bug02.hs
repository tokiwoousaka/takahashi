module Bug02(bug02) where
import Control.Monad.Takahashi
import Control.Lens
import Control.Monad.State

bug02 :: IO ()
bug02 = do
  writeSlide "../contents/Bug02_fix.html" presentation
  putStrLn "Sucess."

presentation :: Taka ()
presentation = do
  slideTitle .= "Title"
  bindPage . testCont $ parCont "Text"
  bindPage $ testCont (testCont $ parCont "Text")
  bindPage $ testCont (testCont (testCont $ parCont "Text"))

testCont :: Contents -> Contents
testCont cont =
  twinLeftCont
    ( listCont
      [ "Value1", "Value3", "Value4", "Value5" ]
    )
    ( verticalCont
      [ imgCont HStretch "../img/my_icon.gif"
      , cont
      ]
    )


