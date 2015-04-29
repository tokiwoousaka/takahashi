module Main where
import Control.Monad.Takahashi
import Control.Lens
import Control.Monad.State

main :: IO ()
main = do
  writeSlide "../contents/20150530LensPrism.html" presentation
  putStrLn "Sucess."

presentation :: Taka ()
presentation = do
  setOptions

  ---- Lensの基本
  --stateSandbox $ do  
  --  title "LensでHaskellをもっと格好良く！" 
  --    $  "2015/5/30 Lens&Prism勉強会\n"
  --    ++ "by ちゅーん(@its_out_of_tune)"
  --slideTitle .= "自己紹介"
  --profile
  --header "HaskellのLens" abountLens

  ---- Optic/Lens/Prism
  --stateSandbox $ do  
  --  slideFontSize .= Just 50
  --  title "Opticから見たLens/Prism" 
  --    $  "2015/5/30 Lens&Prism勉強会\n"
  --    ++ "by ちゅーん(@its_out_of_tune)"
  --header "Lensの限界" lensLimit
  --header "Prismでパターンマッチ" prismPatternMuch
  header "Prismの合成" prismCoposition
  header "State上のPrism" prismWithState
  --header "色々なFunctor" $ return ()
  --header "LensからOpticへ" $ return ()
  --header "Prismの仕組み" $ return ()
  --header "Opticで全体を見渡す" $ return ()
  --header "おまけ" $ return () --圏論の話をちょっとする

  -- end
  slideTitle .= ""
  taka "ありがとうございました\nm(_ _)m"

--------
-- profile

profile :: Taka ()
profile = do
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont
        [ "野生のHaskller(27♂)"
        , "東京都近郊に生息・休職中\n\n"
        , "クルージング(スケボー)"
        , "SOUND VOLTEX(音ゲー)"
        , "リトルノア（スマフォゲー）\n\n"
        , "ヲ級ちゃん可愛い"
        , "艦これやってない"
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
    ++ "　高橋メソッドのスライド作成用に作った言語内DSL\n"
    ++ "　大幅に拡張し複雑なスライドも作れるようになった。\n"
    ++ "　本スライドもこれで作成しました"
    ,  "Sarasvati：\n"
    ++ "　オーディオインターフェイス\n"
    ++ "　PortAudioのラッパーのラッパーとして開発中\n"
    ,  "Arare：\n"
    ++ "　Sarasvatiをベースに、\n"
    ++ "　HaskellのDTM環境を作ろうとごにょごにょ企画中。\n"
    ++ "　DSLベースを想定しているので多分DAWにはならない。"
    ]

--------
-- aboutLens

abountLens :: Taka ()
abountLens = do
  par
    $  "2013/3/31 ekmett勉強会で、\n"
    ++ "Haskellのlensについて発表しました。\n\n"
    ++ "基本的な使い方から\n"
    ++ "動作原理まで網羅的に紹介しています。\n\n"
    ++ "まずは、当時のスライドを使ってLensの説明を行います。"
  taka "旧スライドでの発表"
  par
    $  "いかかでしょうか、HaskellのLensのアプローチは\n"
    ++ "Scalaのそれとはずいぶん違う事に気がついたと思います。\n"
    ++ "Haskellだからこそ実現可能なこのLensの実装スタイルは\n"
    ++ "考案者の名前を取ってvan Laarhoven lensと呼ばれるそうです。\n\n"
    ++ "ekmettによるlens実装は、van Laarhoven lenをさらに拡張し、\n"
    ++ "使いやすくまとめたものになっています。\n\n"
    ++ "本日は、このlensパッケージを掘り下げて解説し、\n"
    ++ "Laarhovenスタイルの優れた特徴をお伝えできればと思います"

--------
-- lensLimit

lensLimit :: Taka ()
lensLimit = do
  twinBottom
    ( parCont 
      $  "Lensアクセッサを利用すれば、\n"
      ++ "次のようにして複雑な構造へアクセスする事が出来るのでした。"
    )
    ( codeCont
      $  "(1, (2, 3, (4, 999)), 6)^._2._3._2 -- 999\n\n"
      ++ "(1, (2, 3, (4, 5)), 6)&_2._3._2.~999 -- (1, (2, 3, (4, 999)), 6)"
    )
  vertical 
    [ parCont 
      $  "それでは、次のfooような構造から\n"
      ++ "\"999\"を操作したい場合はどうすれば良いでしょう？\n\n"
      ++ "もちろん、barのような場合も考慮しなくてはいけません。"
    , codeCont
      $  "let foo\n"
      ++ "  = (1, Left (999, 3), 4) :: (Int, Either (Int, Int) String, Int)\n\n"
      ++ "let bar\n"
      ++ "  = (1, Right \"Test\", 4) :: (Int, Either (Int, Int) String, Int)"
    ]
  twinBottom
    ( parCont 
      $  "まずは値をGetする方法を考えてみます。"
    )
    ( codeCont
      $  "print $ case foo^._2 of \n"
      ++ "  Left inner -> Just (inner^._1)\n"
      ++ "  Right _ -> Nothing\n\n"
      ++ "print $ case bar^._2 of \n"
      ++ "  Left inner -> Just (inner^._1)\n"
      ++ "  Right _ -> Nothing"
    )
  taka "(´ﾟдﾟ｀)ｴｰ"
  twinBottom
    ( parCont 
      $  "Setしたい場合はどうすれば良いでしょうか？"
    )
    ( codeCont
      $  "(_2%~(\\case \n"
      ++ "  Left x -> Left $ x&_1.~111\n"
      ++ "  Right x -> Right x)) foo\n\n"
      ++ "(_2%~(\\case \n"
      ++ "  Left x -> Left $ x&_1.~111\n"
      ++ "  Right x -> Right x)) bar\n"
    )
  taka "｡･ﾟ･(ﾉ∀`)･ﾟ･｡"

--------
-- prismPatternMuch

prismPatternMuch :: Taka ()
prismPatternMuch = do
  vertical
    [ parCont
      $  "LensのアクセッサにはEitherやMaybeのような直和型、\n"
      ++ "つまりパターンマッチが必要な型に対する、\n"
      ++ "アクセス能力がありません。\n\n"
      ++ "このような場合、Prismという型を持つアクセッサを使います。"
    , codeCont
      $  "type Prism s t a b = ... \n\n"
      ++ "_Left :: Prism (Either a c) (Either b c) a b\n"
      ++ "_Right :: Prism (Either c a) (Either c b) a b\n"
    ]
  vertical
    [ parCont 
      $  "Prismのアクセッサから値を取得するには、(^?)演算子を使います。\n\n"
      ++ "この演算子はMaybe型を返し、値が取得できなかった場合、\n"
      ++ "結果はNothingとなります。"
    , codeCont
      $  " let left5 = Left 5 :: Either Int String\n"
      ++ " let rightHoge = Right \"Hoge\" :: Either Int String\n\n"
      ++ " left5^?_Left      -- Just 5\n"
      ++ " left5^?_Right     -- Nothing\n"
      ++ " rightHoge^?_Left  -- Nothing\n"
      ++ " rightHoge^?_Right -- Just \"Hoge\""
    ]
  vertical
    [ parCont 
      $  "また、Prismはパターンにマッチした場合のみ値を変更可能な、\n"
      ++ "Setterとして機能します。"
    , codeCont
      $  "left5&_Left.~999      -- Left 999\n\n"
      ++ "rightHoge&_Left.~999  -- Right \"Hoge\""
    , parCont
      $  "使い方はLensの場合と一緒です。"
    ]
  vertical
    [ parCont 
      $  "さらに、詳細はまた後ほど説明しますが、取得したい値が、\n"
      ++ "Monoidの場合に限り、(^.)演算子による値の取得が可能です。\n\n"
      ++ "もしパターンマッチ出来なかった場合の値はmemptyになります。"
    , codeCont
      $  "Just \"hoge\"^._Just                  -- OK \"hoge\"\n"
      ++ "Just 114514^._Just                  -- NG\n"
      ++ "Just (Sum 184)^._Just               -- OK Sum { getSum = 184 }\n"
      ++ "(Nothing :: Maybe (Sum Int))^._Just -- OK Sum { getSum = 0 }\n"
    ]
  twinTop
    ( parCont
      $  "Prismはre関数を使う事によって、\n"
      ++ "逆にデータコンストラクタを被せるアクセッサになります。\n"
      ++ "この場合、値をSetする事は出来ません。\n\n"
      ++ "同様の事は、to関数を使っても実現出来ますね。"
    )
    ( codeCont
      $  "print $ 100^.re _Just -- Just 100\n\n"
      ++ "print $ 100^.to Just  -- Just 100"
    )
  twinBottom
    ( parCont
      $  "makePrisms関数を使えば、\n"
      ++ "自分で定義した型に対してPrismアクセッサを作成できます。\n"
    )
    ( codeCont
      $  "data Foo a b = Hoge a | Piyo b | Fuga String \n"
      ++ "  deriving (Show, Read, Eq, Ord)\n\n"
      ++ "makePrisms ''Foo\n\n"
      ++ "------\n\n"
      ++ "_Hoge :: Prism (Foo a c) (Foo b c) a b\n"
      ++ "_Piyo :: Prism (Foo c a) (Foo c b) a b\n"
      ++ "_Fuga :: Prism (Foo a b) (Foo a b) String String\n\n"
    )

--------
-- prismCoposition

prismCoposition :: Taka ()
prismCoposition = do
  twinBottom
    ( parCont 
      $  "PrismもLensと同様、関数合成によって合成出来ます。"
    )
    ( codeCont
      $  "let justLeft = Just (Left 5) :: Maybe (Either Int String)\n"
      ++ "let justRight = Just (Right \"Hello\") :: Maybe (Either Int String)\n\n"
      ++ "justLeft^?_Just._Left   -- Just 5\n"
      ++ "justLeft^?_Just._Right  -- Nothing\n"
      ++ "justRight^?_Just._Right -- Just \"Hello\"\n"
      ++ "justRight^._Just._Right -- \"Hello\""
    )
  twinBottom
    ( parCont 
      $  "仮に、PrismとLensを組み合わせて合成しても、\n"
      ++ "もちろんアクセッサとしても利用できます。"
    )
    ( codeCont
      $  "let foo = (1, Left (999, 3), 4) \n"
      ++ "    :: (Int, Either (Int, Int) String, Int)\n"
      ++ "let bar = (1, Right \"Test\", 4) \n"
      ++ "    :: (Int, Either (Int, Int) String, Int)\n\n"
      ++ "print $ foo^?_2._Left._1     -- Just 999\n"
      ++ "print $ foo&_2._Left._1.~111 -- (1,Left (111,3),4) \n"
      ++ "print $ bar^?_2._Right       -- Just \"Test\"\n"
      ++ "print $ bar^._2._Rightn      -- \"Test\""
    )
  vertical
    [ parCont
      $  "一度でもLensと合成したアクセッサに対して、\n"
      ++ "re関数を使う事は出来ませんが、Prism同士を合成したアクセッサは、\n"
      ++ "re関数に適用出来ます。"
    , codeCont
      $  "  re (_Just._1)                 -- NG\n\n"
      ++ "  (100^.re (_Just._Left) \n"
      ++ "    :: Maybe (Either Int Int))  -- OK Just (Left 100)"
    ]
  vertical
    [ parCont
      $  "re関数を使って作成したPrismアクセッサを合成したものと、\n"
      ++ "Prismアクセッサを合成したものをre関数に適用した場合では、\n"
      ++ "結果の構造が逆になるため、注意してください。"
    , codeCont
      $  "print $ (100^.re _Just.re _Left\n"
      ++ "  :: Either (Maybe Int) Int)  -- Left (Just 100) \n\n"
      ++ "print $ (100^.re (_Just._Left)\n"
      ++ "  :: Maybe (Either Int Int))  -- Just (Left 100)"
    ]

-------------------------------------------------
-- helper

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

