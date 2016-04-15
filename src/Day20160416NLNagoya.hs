module Day20160416NLNagoya(day20160416NLNagoya) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20160416NLNagoya :: IO ()
day20160416NLNagoya = do
  let fileName = "contents/day20160416NLNagoya"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions
  stateSandbox $ do
    slideFontSize .= Just 60
    title "Takahashi Monad" 
      $  "2015/2/13 ちゅーん(@its_out_of_tune)\n"
      ++ "2015/2/15　更新\n\n"
      ++ "→キーで次のページへ"
  profile
  --header "はじめに" introduction

-------------------------------------------------
-- profile

profile :: Taka ()
profile = do
  slideTitle .= "自己紹介"
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont
        [ "野生のHaskller(28♂)"
        , "春からなごやこわい\n\n"
        , "クルージング(スケボー)"
        , "ボルダリング\n\n"
        , "スプラトゥーン"
        , "当たらない方のチャージャー使い"
        ]
      )
      ( verticalCont
        [ imgCont WStretch "../img/my_icon2.gif"
        , parCont2
          $  "HN:　ちゅーん\n\n"
          ++ "Twitter:\n"
          ++ "　@its_out_of_tune\n"
          ++ "Github:\n"
          ++ "　tokiwoousaka\n"
        ]
      )
  list
    [  "Takahashi Monad：\n"
    ++ "　スライド作成用の言語内DSL\n" 
    ++ "　本スライドもこれで作成\n"
    ,  "Sarasvati：\n"
    ++ "　永遠に開発中のオーディオインターフェイス\n" ++ "　PortAudioのラッパーのラッパー\n"
    ,  "ブログ：http://tune.hateblo.jp/\n"
    ++ "　ポーカーゲームを作る連載やってます"
    ]
  
