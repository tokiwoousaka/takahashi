module Day20150213takahashi(day20150213takahashi) where
import Control.Lens
import Control.Monad.Takahashi
import Control.Monad.State

day20150213takahashi :: IO ()
day20150213takahashi = do
  let fileName = "contents/20150213takahashi.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"
 
----
 
presentation :: Taka ()
presentation = do
  setOptions
  stateSandbox $ do
    slideFontSize .= Just 60
    title "Takahashi Monad" 
      $  "2015/2/13 ちゅーん(@its_out_of_tune)\n"
      ++ "2015/2/15　更新\n\n"
      ++ "→キーで次のページへ"
  header "はじめに" introduction
  header "基本的な使い方" basic
  header "高度なレイアウト" sophisticate
  header "画面デザイン" design
  header "まとめ" summary
 
 
introduction :: Taka ()
introduction = do
  par
    $  "Takahashi Monadは、\n"
    ++ "Haskellでスライドを作成するための言語内DSLです。\n"
    ++ "このスライドも、同DSLを用いて作成しました。\n\n"
    ++ "Takahashiという名称は本ライブラリが高橋メソッドと呼ばれる、\n"
    ++ "巨大な文字／簡潔な文章を次々と表示していくスライドを用いた、\n"
    ++ "プレゼン技法を実現するために開発された事に由来します。\n\n"
    ++ "その後、同様の仕組みでよりちゃんとしたスライドが作成できれば、\n"
    ++ "便利だと考えるようになり、大幅に機能拡張を行いました。\n"
  par
    $ "画面が崩れるよ場合、縮小して文字サイズを下げる事によって、\n"
    ++ "綺麗に表示されるようになる可能性があります。\n\n"
    ++ "本スライドは、\n"
    ++ "既にいくつかの環境＆ブラウザで動作確認を行っていますが\n"
    ++ "もし正常に動作しないなどの問題がありましたら、\n"
    ++ "開発者にご一報いただければ幸いです。\n"
  
  twinBottom
    ( parCont "Takahashi Monadには、以下のような特徴があります。")
    ( listCont2
        [ "DSLなのでテキストエディタでスライドを作成できる"
        , "比較的自由にレイアウトを構成可能"
        , "Haskellのコンパイル環境さえ整っていれば導入が楽(になるはず)"
        , "モナドとして提供されているため拡張性が非常に高い"
        , "高橋メソッドのスライドを生成するのに優れている"
        ]
    )
  vertical
    [ parCont 
      $  "以下のどちらかの方法で、\n"
      ++ "Takahashiモナドを導入できます。" 
    , listCont2
      [ "githubからソースコードをcloneして直接 cabal install"
      , "cabal install takahashi でHackageからインストール"
      ]
    ]
 
----
 
basic :: Taka ()
basic = do
  vertical
    [  verticalCont
      [ parCont
        $ "まず、Takahashi Monadを構成するもっとも重要な関数を紹介します。\n"
      , codeCont
        $ "writeSlide :: String -> Taka () -> IO ()\n"
      ]
    , parCont
      $  "writeSlide関数は最初の引数で指定されたファイル名に、\n"
      ++ "次に渡されたTaka型の内容を書き込みます。\n" 
      ++ "Taka型はプレゼンテーション情報そのものを表すモナドです。\n" 
      ++ "do構文でTaka型の情報を記述していく事で、\n" 
      ++ "プレゼンテーションを作成していく事ができます。" 
    ]
  vertical
    [ parCont
      $  "実際のプログラムはどのようになるか見てみましょう。\n\n"
      ++ "以下のようなコードを実行する事によって、\n"
      ++ "Out.htmlにスライドが出力されます。"
    , codeCont
      $  "module Main where\n"
      ++ "import Control.Monad.Takahashi\n"
      ++ "import Control.Lens --表示設定のアクセッサを利用するのに必要です\n\n"
      ++ "main = writeSlide \"Out.html\" presentation\n\n"
      ++ "presentation :: Taka ()\n"
      ++ "presentation = ... --ここにプレゼンテーションの内容を記述していきます"
    ]
  vertical
    [ parCont
      $  "高橋メソッド形式で、短い文章を次々と表示していくだけの、\n"
      ++ "簡単なスライド作成するだけであれば以下のサンプルのように、\n"
      ++ "taka関数を次々と記述していくだけで、とても簡単に作成できます。\n"
      ++ "次ページから、実行結果を見ていきましょう。"
    , codeCont 
      $  "presentation = do\n"
      ++ "  taka \"高橋メソッド\"\n"
      ++ "  taka \"巨大な文字\"\n"
      ++ "  taka \"簡潔な言葉\"\n"
      ++ "  taka \"余計な情報がなく\\n画面が見やすい\"\n"
      ++ "  taka \"LTなどで活躍\"\n"
    ]
  sample $ do
    taka "高橋メソッド"
    taka "巨大な文字"
    taka "簡潔な言葉"
    taka "余計な情報がなく\n画面が見やすい"
    taka "LTなどで活躍"
  code
    (  "他にも、さまざまな情報を出力するための関数が用意されています\n"
    ++ "次ページから、以下のコードの実行結果を見ていきましょう。"
    )
    (  "presentation = do\n"
    ++ "  ---- 段落 ----\n"
    ++ "  par \"段落\\n自由な文章を記述できます。\"\n"
    ++ "  ---- リスト ----\n"
    ++ "  list [\"項目１\", \"項目２\", \"項目３\", \"項目４\"]\n"
    ++ "  ---- 画像 ----\n"
    ++ "  img HStretch \"../img/jpeg01.jpeg\"\n"
    ++ "  ---- コード ----\n"
    ++ "  code \"コードは等倍フォントで表示されます\"\n"
    ++ "    \"main :: IO ()\\nmain = putStrLn \\\"Hello, World!\\\"\""
    )
  sample $ do
    par "段落\n自由な文章を記述できます。"
    list ["項目１", "項目２", "項目３", "項目４"]
    img HStretch "../img/jpeg01.jpeg"
    code "コードは等倍フォントで表示されます" 
      "main :: IO ()\nmain = putStrLn \"Hello, World!\""
  vertical
    [ parCont
      $  "Lensの代入演算子(.=)を使い、slideTitleを設定する事により、\n"
      ++ "スライド上部にタイトルを表示させる事ができます。\n\n"
      ++ "次ページから、以下のコードの実行結果を見ていきましょう。"
    , codeCont
      $   "presentation = do\n"
      ++  "  par \"このページにはタイトルは表示されません。\"\n"
      ++  "  slideTitle .= \"タイトル\"\n"
      ++  "  par \"このページにはタイトルが表示されます。\"\n"
      ++  "  slideTitle .= \"\"\n"
      ++  "  par \"空文字列を設定すると、\\nタイトルは表示されなくなります。\""
    ]
  sample $ do
    par "このページにはタイトルは表示されません。"
    slideTitle .= "タイトル"
    par "このページにはタイトルが表示されます。"
    slideTitle .= ""
    par "空文字列を設定すると、\nタイトルは表示されなくなります。"
 
sophisticate :: Taka ()
sophisticate = do
  par
    $  "Takahashi Monad には、段落やリスト等のコンテンツを、\n"
    ++ "スライド上に自由に配置するための仕組みがあります。\n\n"
    ++ "例えば、グラフの画像とそれに対する説明文章を、\n"
    ++ "一つの画面に収めたい時などに便利です。\n\n"
    ++ "実際にどのような配置を行う事ができるのか、\n"
    ++ "次ページで少し複雑なサンプルを見てみましょう。\n"
  sample $ do
    slideTitle .= "複雑な構成の例"
    twinLeft
      ( verticalCont
        [ listCont ["左上項目１", "左上項目２", "左上項目３"]
        , codeCont "main :: IO ()\nmain \n  = putStrLn \"Hi!\""
        ]
      )
      ( imgCont HStretch "../img/jpeg01.jpeg" )
  vertical
    [ parCont 
      $  "例えば、横にコンテンツを分割するための関数にhorizonがあります。\n"
      ++ "GHCiで型を見てみましょう。"
    , codeCont 
      $  "ghci> :t horizon\n"
      ++ "horizon:: [Contents] -> Taka ()"
    , parCont 
      $  "Contentsという型のリストを引数に取り、Taka ()型、\n"
      ++ "つまり、プレゼンテーションを構成する型を返します。"
    ]
  vertical
    [ parCont
      $  "Contents型は、いわばスライドを構築するための部品です。\n\n"
      ++ "Takahashi Monadは段落やリスト等の、\n"
      ++ "Contentsを作成するための関数をいくつか用意しています。"
    , codeCont 
      $  "parCont :: String -> Contents              --段落\n"
      ++ "listCont :: [String] -> Contents           --リスト\n"
      ++ "imgCont :: DrawType -> String -> Contents  --画像\n"
      ++ "codeCont :: String -> Contents             --コード"
    ]
  vertical
    [ parCont 
      $  "既におわかりのように、horizon関数にContentsのリストを渡す事で、\n"
      ++ "横一列にコンテンツを並べる事ができるのです。\n\n"
      ++ "次ページで、以下のコードの実行結果を見てみましょう。"
    , codeCont 
      $  "presentation = do\n"
      ++ "  horizon\n"
      ++ "    [ parCont \"左\"\n"
      ++ "    , parCont \"中\"\n"
      ++ "    , parCont \"右\"\n"
      ++ "    ]"
    ]
  sample $ do
    horizon
      [ parCont "左"
      , parCont "中"
      , parCont "右"
      ]
  code
    (  "horizonのように、複数のContentsを組み合わせて、\n"
    ++ "ひとつのページを構成するための関数には、何種類かあります。"
    )
    (  "horizon :: [Contents] -> Taka ()              --横分割\n"
    ++ "vertical :: [Contents] -> Taka ()             --縦分割\n"
    ++ "twinLeft :: Contents -> Contents -> Taka ()   --左広の横２分割\n"
    ++ "twinRight :: Contents -> Contents -> Taka ()  --右広の横２分割\n"
    ++ "twinTop :: Contents -> Contents -> Taka ()    --上広の縦２分割\n"
    ++ "twinBottom :: Contents -> Contents -> Taka () --下広の縦２分割\n"
    )
  vertical
    [ parCont
      $  "また、Contentsを元にContentsを構成する関数もあります。\n\n"
      ++ "これらを組み合わる事によって、\n"
      ++ "より複雑なページを作成する事も可能です。"
    , codeCont
      $  "horizonCont :: [Contents] -> Contents              --横分割\n"
      ++ "verticalCont :: [Contents] -> Contents             --縦分割\n"
      ++ "twinLeftCont :: Contents -> Contents -> Contents   --左広の横２分割\n"
      ++ "twinRightCont :: Contents -> Contents -> Contents  --右広の横２分割\n"
      ++ "twinTopCont :: Contents -> Contents -> Contents    --上広の縦２分割\n"
      ++ "twinBottomCont :: Contents -> Contents -> Contents --下広の縦２分割\n"
    ]
  code
    (  "以上の事を踏まえて、先ほどお見せした複雑な構成は、\n"
    ++ "次のコードで実現出来る事がわかると思います。\n"
    )
    (  "presentation = do\n"
    ++ "  slideTitle .= \"複雑な構成の例\"\n"
    ++ "  twinLeft\n"
    ++ "    ( verticalCont\n"
    ++ "      [ listCont [\"左上項目１\", \"左上項目２\", \"左上項目３\"]\n"
    ++ "      , codeCont \"main :: IO ()\\nmain\\n  = putStrLn \\\"Hi!\\\"\"\n"
    ++ "      ]\n"
    ++ "    )\n"
    ++ "    ( imgCont HStretch \"../img/jpeg01.jpeg\" )"
    )
 
design :: Taka ()
design = do
  vertical
    [ parCont
        $  "Takahashi Monadには、Lensのアクセッサで操作する事が可能な、\n"
        ++ "ちょっとした画面デザインを変更するための設定が用意されています。\n"
        ++ "例えば、以下のコードによって、parやlistの表示色が緑色になります。\n\n"
        ++ "次ページで、以下のコードを実行した結果を確認してみましょう。"
    , codeCont
        $  "contentsOption.fontColor .= Just (Color 0 100 0)   --文字色\n"
        ++ "contentsOption.bgColor .= Just (Color 200 255 200) --背景色\n"
        ++ "vertical\n"
        ++ "  [ parCont \"色変更のサンプル\"\n"
        ++ "  , listCont [\"項目１\", \"項目２\", \"項目３\"]\n"
        ++ "  ]"
    ]
  sample $ do
    contentsOption.fontColor .= Just (Color 0 100 0) 
    contentsOption.bgColor .= Just (Color 200 255 200)
    vertical
      [ parCont "色変更のサンプル"
      , listCont ["項目１", "項目２", "項目３"]
      ]
  vertical
    [ parCont 
      $ "slideFontSizeを設定すると、全体の文字サイズを変更できます。\n" 
      ++ "また、コンテンツの種類によって、個別に文字サイズを変更可能です。\n\n"
      ++ "今回も、次ページで実行結果を確認してみましょう。"
    , codeCont
      $  "presentation = do\n"
      ++ "  slideFontSize .= Just 100\n"
      ++ "  titleOption.blockFontSize .= Just 20\n\n"
      ++ "  slideTitle .= \"小さなタイトル\"\n"
      ++ "  par \"巨大な文章\""
    ]
  sample $ do
    slideFontSize .= Just 100
    titleOption.blockFontSize .= Just 20
    slideTitle .= "小さなタイトル"
    par "巨大な文章"
  vertical
    [ parCont
      $  "このスライドでは全ての設定項目の紹介は行いません。\n"
      ++ "設定項目の一覧はHackageのSlideOptionを参照してください。"
    , parCont2
      $  "http://hackage.haskell.org/package/takahashi-0.2.0.2/\n"
      ++ "docs/Control-Monad-Takahashi-Slide.html#t:SlideOption"
    , parCont
      $  "尚、上記URLは2015/02/15現在の最新です。"
    ]
 
summary :: Taka ()
summary = do
  par
    $  "以上、TakahashiMonadを用いたスライド作成について紹介しました\n\n"
    ++ "普段からHaskellを使われていて、\n"
    ++ "手になじむ発表資料作成ツールが見つからないという人は\n"
    ++ "試してみては如何でしょうか。\n\n"
    ++ "本ライブラリや生成されたスライドについて何か問題を発見した方は、\n\n"
    ++ "https://github.com/tokiwoousaka/takahashi\n\n"
    ++ "までissue報告やPull Request等いただければ幸いです。\n\n"
  taka "ありがとうございましたm(_ _)m"
 
----
 
setOptions :: Taka ()
setOptions = do
  slideFontSize .= Just 40
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
  codeOption.blockFontSize .= Just 30
 
 
-- 見出しページおよびタイトル付与
header :: String -> Taka () -> Taka ()
header s t = do
  slideTitle .= ""
  stateSandbox $ do
    slideFontSize .= Just 60
    taka2 s
  slideTitle .= s
  t
 
-- サンプル表示、一時的に設定値をリセット
sample :: Taka () -> Taka ()
sample t = do
  tmp <- get
  put defaultSlideOption
  t
  put tmp
