module Main where
import Control.Monad.Takahashi

main :: IO ()
main = writeTakahashi "../html/Temp.html" "out.html" presen

presen :: Taka ()
presen = do
  title "Takahashi Monad" "→キーで進む"

  taka "高橋メソッドとは"
  taka "でっかい文字"
  taka "簡単な言葉"
  taka "文字だけで勝負"
  taka "必要にかられて生まれたらしい"
  taka "でもメリット沢山"

  taka "メリット１"
  taka "見やすい"
  taka "メリット２"
  taka "表現が簡潔"
  taka "少ない文字数が推敲の指針に！"
  taka "メリット３"
  taka "本番に強い"
  taka "緊張してど忘れしたら"
  taka "とりあえずページをめくれ！"

  taka "Takahashi Monad"
  taka "Haskellで型安全に高橋メソッドｗ"
  taka "HTML手書きよりは楽でしょ？"
  taka "地味に機能色々"
 
  changeFontStrength Strong
  taka "さらに文字をでっかく"
  changeFontStrength Weak
  taka "長めの文章を書く場合とか演出とかのためにこうやって字を小さく表示する事もできるよ"
  changeFontStrength Middle

  changeColor (Color 180 0 0) (Color 255 100 100)
  taka "赤く表示"

  changeColor (Color 0 0 180) (Color 100 100 255)
  taka "青く表示"

  changeColor (Color 0 0 0) (Color 255 255 255)
  taka "Monadだから拡張簡単"
  taka "スライドをプログラミング"
  taka "未知なる可能性？ｗ"
  taka "問題点　沢山"
  taka "セキュリティ最悪"
  taka "多分、XSS余裕っす"
  taka "デザインバランス最悪"
  taka "高橋メソッドとはいえもうちょっと・・・"
  taka "こういうスライドはちょくちょく作るので"
  taka "多分徐々に改善されます"
  taka "コードも表示できるようにしたいしね？"

  taka "ありがとうございました"

-- 以下、バージョンアップで標準搭載予定
changeColor :: Color -> Color -> Taka ()
changeColor fc bc = do
  opt <- get
  put $ opt
    { divForeColor = fc
    , divBackColor = bc
    }

changeFontStrength :: Strength -> Taka ()
changeFontStrength s = do
  opt <- get
  put $ opt { divStrength  = s }

