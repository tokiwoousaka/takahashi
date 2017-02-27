module Day20160627Sunotora(day20160627Sunotora) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20160627Sunotora:: IO ()
day20160627Sunotora= do
  let fileName = "../contents/day201605627Sunotora.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions
  stateSandbox $ do
    slideFontSize .= Just 60
    title "Haskellでポーカー" 
      $  "2016/6/27 ちゅーん(@its_out_of_tune)\n"
      ++ "for すのとら迎撃会"
  header "はじめに" first
  header "解説" readBlog
  header "おわりに" summary

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"

-----------------------------------------------
-- first

first :: Taka ()
first = do
  slideTitle .= "自己紹介"
  taka "省　略"
  slideTitle .= "近状報告"
  taka "NuGetつらい"
  slideTitle .= "ポーカーの連載"
  vertical
    [ parCont "ブログでポーカーを作る連載"
    , codeCont "http://tune.hateblo.jp/entry/2015/05/12/023112"
    , parCont "絶賛放置中"
    ]
  twinBottom
    ( parCont "何故ポーカーなのか"
    )
    ( listCont2
      [ "（ドローポーカーなら）皆知っている"
      , "程良いボリューム感"
      , "関数型的なアイディアを応用しやすい"
      , "何より楽しい"
      ]
    )
  bigList
    [ "テキサスホールデムのが好き"
    , "でもルールが複雑"
    , "日本ではドローポーカーの方が有名"
    , "てなワケでドローポーカー"
    ] 
  taka "デモ"
  slideTitle .= "今日話す事"
  bigList
    [ "Haskell開発環境はもうOKだよね？"
    , "全部話すとけっこうなボリューム"
    , "今日は役の判定処理中心に読むよ"
    , "関数型的なポイントを押さえて駆け足"
    , "わからんかった所はブログ読んでね"
    ]

-----------------------------------------------
-- readBlog

readBlog :: Taka () 
readBlog = do
  slideTitle .= "解説"
  taka "ブログを読みながら説明"

-----------------------------------------------
-- summary

summary :: Taka ()
summary = do
  slideTitle .= "まとめ"
  bigList
    [  "制約の強い型でバグを防げる"
    ,  "型はドキュメントになる"
    ,  "型を設計する事で全体像が見えてくる"
    ,  "関数型には関数を糊付けする道具が沢山"
    ,  "小さく作って糊付けしていく\n"
    ++ "　　それが良い関数型スタイル！"
    ]
