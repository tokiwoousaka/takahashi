module Day20170521Church(day20170521Church) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20170521Church :: IO ()
day20170521Church = do
  let fileName = "../contents/day20170521Church.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions
  title "いちじかんめ\nさんすう" 
    $  "2017/5/24 ちゅーん(@its_out_of_tune)\n"
    ++ "for りょかさん迎撃会"

  header "授業開始" first
  header "計算と\nチューリングマシン" aboutCalc
  header "ラムダ計算" lambdaCalc
  header "チャーチ数" churchNumber
  header "まとめ" summary

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"

first :: Taka ()
first = do
  slideTitle .= "もんだい いち"
  twinBottom
    ( takaCont "2 + 3 = ?"
    )
    ( listCont2
      [ "A : 4"
      , "B : 5"
      , "C : 6"
      , "D : 114514"
      ]
    )
  taka "なんでだよ!!!"
  taka "はい、次"
  slideTitle .= "もんだい に"
  taka "どうして\n2 + 3 = 5 になるんですか？"
  taka "ぜんぜんわからない\n俺たちは雰囲気で\n算数をやっている"
  slideTitle .= "でも……"
  taka "計算機の仕組みは\nそうもいかない"

aboutCalc :: Taka ()
aboutCalc = do
  slideTitle .= "二進数"
  vertical
    [ takaCont "皆さんご存知のアレ"
    , codeCont "0010 + 0011 = 0101"
    ] 
  slideTitle .= "全加算機"
  img WStretch "../img/church/zenkasanki.png"
  horizon
    [ parCont "実際の\n計算機は\nもっと複雑"
    , imgCont HStretch "../img/church/tukurikata.jpg"
    ] 
  slideTitle .= "昔の科学者が考えたこと"
  taka "すごい昔"
  taka "今のコンピュータが"
  taka "生まれる前"
  taka "「計算を機械化したい」"
  taka "そのために"
  taka "あらゆる計算ができる"
  taka "シンプルなモデル"
  taka "色々と考えた"
  slideTitle .= "チューリングマシン"
  taka "アランさんが考えた"
  taka "さいきょーの計算機"
  taka "無限に長い"
  taka "0, 1が並んだ"
  taka "テープと"
  taka "簡単な命令を"
  taka "実行できる"
  taka "ヘッド"
  img HStretch "../img/church/s_machine.jpg"
  taka "詳細はさておき"
  taka "今のコンピュータの"
  taka "元になった理論"
  slideTitle .= "チューリング完全"
  taka "チューリングマシンに可能な"
  taka "どんな計算でも出来る"
  taka "凄い計算モデル"
  taka "それがチューリング完全"
  taka "例 : ランダムアクセスマシン"
  taka "例 : 今のコンピュータ"
  taka "(無限のメモリ空間があれば)"
  taka "例 : C言語"
  taka "例 : ラムダ計算"
  taka "これが本題"
  
lambdaCalc :: Taka ()
lambdaCalc = do
  slideTitle .= "ラムダ計算"
  taka "アロンゾさんと"
  taka "スティーヴンさんが"
  taka "作った"
  taka "関数と評価の"
  taka "計算モデル"
  taka "プログラミング言語"
  taka "LISPの"
  taka "元になった理論"
  taka "形式的な\n定義もあるけど"
  taka "今日はざっくり"
  taka "駆けあしで!!"
  vertical
    [ parCont "関数の例"
    , codeCont "λx. x"
    ] 
  vertical
    [ parCont "引数を渡す"
    , codeCont "(λx. x) y"
    ] 
  vertical
    [ parCont "評価した結果"
    , codeCont "y"
    ] 
  vertical
    [ parCont "高階関数"
    , codeCont "(λx .(λy. x y)) z"
    ] 
  vertical
    [ parCont "略記法"
    , codeCont "(λx y. x y) z"
    ] 
  vertical
    [ parCont "評価した結果"
    , codeCont "λy. z y"
    ] 
  vertical
    [ parCont "変数名が変わっても同じ意味"
    , codeCont "λx. x\n    = λy. y"
    ] 
  vertical
    [ parCont "変数名がかぶると\n意味が変わって困る"
    , codeCont "(λa x. a x) x \n    = λx. x x ????"
    ] 
  vertical
    [ parCont "アルファ変換"
    , codeCont "(λa x. a x) x \n    = (λa y. a y) x\n    = λy. x y"
    ] 
  vertical
    [ parCont "これも高階関数"
    , codeCont "(λf x. f x) (λx. x) y"
    ] 
  vertical
    [ parCont "一段階評価"
    , codeCont "(λz. (λx. x) z) y"
    ] 
  vertical
    [ parCont "もう一段階"
    , codeCont "(λx. x) y"
    ] 
  vertical
    [ parCont "最後まで評価"
    , codeCont "y"
    ] 

churchNumber :: Taka ()
churchNumber = do
  slideTitle .= "ラムダ計算と数"
  taka "ラムダ計算は"
  taka "チューリング完全"
  taka "この仕組みだけで"
  taka "コンピューターと"
  taka "同等の"
  taka "あらゆる計算が出来る"
  taka "疑問"
  taka "ラムダ計算には"
  taka "数や演算の定義がない"
  vertical
    [ parCont "ラムダ計算の定義だけでは\n次のような事はできない"
    , codeCont "(λx. x + 3) 2 = 5"
    ] 
  taka "どうやって\n足し算するの？"
  taka "そこでチャーチ数ですよ"
  slideTitle .= "チャーチ数"
  vertical
    [ parCont "高品関数で数を表す"
    , codeCont 
      $  "0 := λf x. f\n"
      ++ "1 := λf x. f x\n"
      ++ "2 := λf x. f (f x)\n"
      ++ "3 := λf x. f (f (f x))\n"
      ++ "...."
    ] 
  vertical
    [ parCont "足し算"
    , codeCont "λm n f x. m f (n f x)"
    ] 
  vertical
    [ parCont "2 + 3 = ???"
    , codeCont "(λm n f x. m f (n f x)) (λf x. f (f x)) (λf x. f (f (f x)))"
    ] 
  vertical
    [ parCont "2 + 3 = 5"
    , codeCont 
      $  "(λm n f x. m f (n f x)) (λf x. f (f x)) (λf x. f (f (f x)))\n"
      ++ "    = λf x. f (f (f (f (f x))))"
    ] 
  taka "…………"
  taka "よくわかんないので"
  taka "ホワイトボードで\n実際に計算"
  taka "超シンプルな仕組みで\n足し算が出来た"
  slideTitle .= "同様に"
  twinBottom
    ( parCont "似たような感じで\nあらゆる計算が表現できる" )
    ( listCont2
      [ "加減乗除や大小比較、同値判定"
      , "Bool値と条件分岐"
      , "タプル(S式も表現できるよ!)"
      , "不動点コンビネータ(再帰処理)"
      ]
    ) 
  
summary :: Taka () 
summary = do
  slideTitle .= "まとめ"
  list
    [ "足し算くらいみんなできる"
    , "コンピュータだとそう簡単にいかない"
    , "昔の人は色々なモデルを考えた"
    , "コンピュータの前進、チューリングマシン"
    , "チューリングマシンと同等->チューリング完全"
    , "ラムダ計算はチューリング完全"
    , "ラムダ計算で足し算->チャーチ数"
    ]
  slideTitle .= "Why ラムダ計算"
  list
    [ "楽しい/面白い\n\n"
    , "ラムダ計算は関数プログラミングの基礎"
    , "考えかたを関数型プログラミングに応用できる"
    , "だいたいWikipediaに書いてあるょ"
    ]

profile :: Taka ()
profile = do
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont
        [ "野生のHaskller(29♂)"
        , "2016年春よりなごやか"
        , "OTR 基盤チームの道化枠\n\n"
        , "雑なゲーム実況"
        , "イカ、ゼルダ、ぷよぷよ"
        , "だいたい全部ヘタ\n\n"
        , "ラット飼いたい"
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

