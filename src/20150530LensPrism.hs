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
  --  title "LensでHaskellを\nもっと格好良く！" 
  --    $  "2015/5/30 Lens&Prism勉強会\n"
  --    ++ "by ちゅーん(@its_out_of_tune)"
  --slideTitle .= "自己紹介"
  --profile
  --header "HaskellのLens" abountLens

  ---- Optic/Lens/Prism
  stateSandbox $ do  
    slideFontSize .= Just 50
    title "Opticから見たLens/Prism" 
      $  "2015/5/30 Lens&Prism勉強会\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  --header "Lensの限界" lensLimit
  --header "Prismでパターンマッチ" prismPatternMuch
  --header "Prismの合成" prismCoposition
  --header "State上のPrism" prismWithState
  header "色々なFunctor" anyFunctor
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
        , "東京都近郊に生息"
        , "休職中\n\n"
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
    ++ "　スライド作成用の言語内DSL\n"
    ++ "　拡張済み／複雑なスライドも作れる\n"
    ++ "　本スライドもこれで作成\n\n"
    ++ "　GHC7.10非対応 。゜。゜（ノД｀）゜。゜。"
    ,  "Sarasvati：\n"
    ++ "　開発中のオーディオインターフェイス\n"
    ++ "　PortAudioのラッパーのラッパー"
    ]

--------
-- aboutLens

abountLens :: Taka ()
abountLens = do
  twinBottom
    ( parCont
      $  "2013/3/31 ekmett勉強会で、\n"
      ++ "Haskellのlensについて発表。\n\n"
    )
    ( listCont
      [ "基本的な使い方"
      , "基本的な仕組みと実装"
      , "簡単な応用等"
      ]
    )
  taka "旧スライドでの発表"
  list
    [ "ScalaのLensと実装が違う？\n 　　-> van Laarhoven lens\n\n"
    , "考案者 van Laarhovenがブログ記事に"
    , "Russell O'Connor証明等を論文に\n\n"
    , "ekmett/lensはvan Laarhoven lensの拡張"
    , "Haskellのlensはもっとすごいぞっ！"
    ]

--------
-- lensLimit

lensLimit :: Taka ()
lensLimit = do
  twinBottom
    ( parCont 
      $  "Lensアクセッサを利用すれば、\n"
      ++ "複雑な構造へアクセスする事が出来る"
    )
    ( codeCont
      $  "(1, (2, 3, (4, 999)), 6)^._2._3._2 -- 999\n\n"
      ++ "(1, (2, 3, (4, 5)), 6)&_2._3._2.~999 -- (1, (2, 3, (4, 999)), 6)"
    )
  vertical 
    [ parCont 
      $  "fooような構造から\"999\"を操作したい場合は？\n"
      ++ "barのような場合は？"
    , codeCont
      $  "let foo = (1, Left (999, 3), 4) \n"
      ++ "    :: (Int, Either (Int, Int) String, Int)\n\n"
      ++ "let bar = (1, Right \"Test\", 4) \n"
      ++ "    :: (Int, Either (Int, Int) String, Int)"
    ]
  twinBottom
    ( parCont 
      $  "頑張ってlensだけでGetする\n"
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
      $  "頑張ってlensだけでSetする"
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
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 80
    par
      $  "lensは便利だけど\n"
      ++ "直和型が混ざると使えない\n\n"
      ++ "　-> そこでPrimsを使おう！"

--------
-- prismPatternMuch

prismPatternMuch :: Taka ()
prismPatternMuch = do
  vertical
    [ parCont
      $  "Lensは直和型(Maybe, Either等)には使えない。\n\n"
      ++ "このような場合、\n"
      ++ "Prismという型を持つアクセッサを使う。"
    , codeCont
      $  "type Prism s t a b = ... \n\n"
      ++ "_Left :: Prism (Either a c) (Either b c) a b\n"
      ++ "_Right :: Prism (Either c a) (Either c b) a b\n"
    ]
  vertical
    [ parCont 
      $  "Prismを使った値の取得には(^?)を使う。\n\n"
      ++ "Maybe型を返し、値が取得できなかった場合、\n"
      ++ "結果はNothingとなる。"
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
      $  "Prismはマッチした場合のみ変更可能な、\n"
      ++ "Setterとして機能する。"
    , codeCont
      $  "left5&_Left.~999      -- Left 999\n\n"
      ++ "rightHoge&_Left.~999  -- Right \"Hoge\""
    , parCont
      $  "使い方はLensと同様"
    ]
  vertical
    [ parCont 
      $  "取得したい値がMonoidの場合に限り、(^.)が使える。\n"
      ++ "マッチ出来なかった場合の値はmemptyになる。"
    , codeCont
      $  "Just \"hoge\"^._Just                  -- OK \"hoge\"\n"
      ++ "Just 114514^._Just                  -- NG\n"
      ++ "Just (Sum 184)^._Just               -- OK Sum { getSum = 184 }\n"
      ++ "(Nothing :: Maybe (Sum Int))^._Just -- OK Sum { getSum = 0 }\n"
    ]
  twinTop
    ( parCont
      $  "Prismはre関数を使う事によって、\n"
      ++ "データコンストラクタを被せるアクセッサになる。\n"
      ++ "値をSetする事は出来ない。\n\n"
      ++ "同様の事は、to関数を使っても実現可能。"
    )
    ( codeCont
      $  "print $ 100^.re _Just -- Just 100\n\n"
      ++ "print $ 100^.to Just  -- Just 100"
    )
  twinBottom
    ( parCont
      $  "makePrisms関数を使えば、\n"
      ++ "独自の型に対してPrismアクセッサを作成できる。\n"
    )
    ( codeCont
      $  "data Foo a b = Hoge a | Piyo b | Fuga String \n"
      ++ "  deriving (Show, Read, Eq, Ord)\n\n"
      ++ "makePrisms ''Foo\n\n"
      ++ "------ 以下のPrismが生成される ------\n\n"
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
      $  "PrismもLensと同様、"
      ++ "関数合成によって合成可能。"
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
      $  "当然、PrismとLensを組み合わせても、\n"
      ++ "アクセッサとして利用可能。"
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
      $  "Lensと合成した後はre関数が使えない。\n"
      ++ "合成したのがPrism同士ならば問題ない。"
    , codeCont
      $  "  re (_Just._1)                 -- NG\n\n"
      ++ "  (100^.re (_Just._Left) \n"
      ++ "    :: Maybe (Either Int Int))  -- OK Just (Left 100)"
    ]
  vertical
    [ parCont
      $  "Prismの合成 -> re関数\n"
      ++ "Prismにre関数 -> 合成\n\n"
      ++ "では、結果の構造が逆になるため注意。"
    , codeCont
      $  "print $ (100^.re _Just.re _Left\n"
      ++ "  :: Either (Maybe Int) Int)  -- Left (Just 100) \n\n"
      ++ "print $ (100^.re (_Just._Left)\n"
      ++ "  :: Maybe (Either Int Int))  -- Just (Left 100)"
    ]

--------
-- prismWithState

prismWithState :: Taka ()
prismWithState = do
  vertical
    [ parCont
      $  "Lens同様、\n"
      ++ "MonadStateインスタンス上で状態へのSetが可能。\n"
    , codeCont
      $  "sample :: State (Int, Bool, Maybe (Int, String)) ()\n"
      ++ "sample = do\n"
      ++ "  _1 .= 100\n"
      ++ "  _3._Just._2 .= \"Hello, Prism!\"\n"
      ++ "  return ()"
    ]
  vertical
    [ parCont
      $  "取り出したい値がモノイドならば\n"
      ++ "use関数を用いた値のGetが出来る。"
    , codeCont
      $  "sample :: State (Int, Bool, Maybe (Int, String)) String\n"
      ++ "sample = do\n"
      ++ "  str <- use $ _3._Just._2\n"
      ++ "  return str"
    ]
  vertical
    [ parCont
      $  "モノイドでない場合はpreuse関数を使う。"
    , codeCont
      $  "sampleState2 :: State (Int, Bool, Maybe (Int, String)) (Maybe Int)\n"
      ++ "sampleState2 = do\n"
      ++ "  int <- preuse $ _3._Just._1\n"
      ++ "  return int"
    ]
  vertical
    [ parCont
      $  "取得したい値がIntならば次のようにしても良い。"
    , codeCont
      $  "sample :: State (Int, Bool, Maybe (Int, String)) (Sum Int)\n"
      ++ "sample = do\n"
      ++ "  int <- use $ _3._Just._1.to Sum\n"
      ++ "  return int"
    ]

--------
-- anyFunctor

anyFunctor :: Taka ()
anyFunctor = do
  vertical
    [ parCont
      $  "Functorのイメージ：\n"
      ++ "　実用上の認識に囚われない方が良い。"
    , parCont2
      $  "Functorの図式"
    ]
  vertical
    [ parCont
      $  "持ち上げ先の矢印を逆にする"
    , parCont2
      $  "Contravariantの図式"
    ]
  vertical
    [ parCont
      $  "FunctorとContravariant"
    , codeCont
      $  "class Functor f where\n"
      ++ "  fmap      :: (a -> b) -> f a -> f b\n\n"
      ++ "class Contravariant f where\n"
      ++ "  contramap :: (a -> b) -> f b -> f a\n"
    ]
  vertical
    [ takaCont
      $  "シンキング・タイム(10秒)"
    , parCont
      $  "Contravariantになるような\n"
      ++ "データ構造を考えてみよう！"
    ]
  vertical
    [ parCont
      $  "例１：関数"
    , codeCont
      $  "newtype Op b a = Op { runOp :: a -> b }\n\n"
      ++ "instance Contravariant (Op r) where\n"
      ++ "  contramap f (Op g) = Op $ g . f"
    ]
  vertical
    [ parCont
      $  "例２：Const"
    , codeCont
      $  "newtype Const a b = Const { getConst :: a }\n\n"
      ++ "instance Contravariant (Const r) where\n"
      ++ "  contramap _ = Const . getConst\n"
    ]
  vertical
    [ parCont
      $  "２つの関数を一つに束ねる"
    , parCont2
      $  "Bifunctorの図式"
    ]
  vertical
    [ parCont
      $  "Bifunctor"
    , codeCont
      $  "class Bifunctor f where\n"
      ++ "  bimap :: (a -> b) -> (c -> d) -> f a c -> f b d\n\n"
      ++ "  first :: (a -> b) -> f a c -> f b c\n"
      ++ "  first f = bimap f id\n\n"
      ++ "  second :: (b -> c) -> f a b -> f a c\n"
      ++ "  second f = bimap id f"
    ]
  vertical
    [ parCont
      $  "Bifunctorの例：タプル、Const 等"
    , codeCont
      $  "instance Bifunctor (,)  where\n"
      ++ "  bimap f g (x, y) = (f x, g y)\n\n"
      ++ "instance Bifunctor Const  where\n"
      ++ "  bimap f _ (Const x) = Const $ f x"
    ]

-------------------------------------------------
-- helper

setOptions :: Taka ()
setOptions = do
  slideFontSize .= Just 50
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

