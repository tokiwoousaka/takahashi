module Day20170315Hourensou(day20170315Hourensou) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20170315Hourensou :: IO ()
day20170315Hourensou = do
  let fileName = "../contents/day20170206otr.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
    title "ほうれんそう" 
      $  "2017/2/27 ちゅーん(@its_out_of_tune)\n"
      ++ "for チョコ meets ワイン"

