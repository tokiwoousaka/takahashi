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
  stateSandbox $ do  
    title "LensでHaskellを\nもっと格好良く！" 
      $  "2015/5/30 Lens&Prism勉強会\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  slideTitle .= "自己紹介"
  profile
  header "HaskellのLens" abountLens

  ---- Optic/Lens/Prism
  stateSandbox $ do  
    slideFontSize .= Just 50
    title "Opticから見たLens/Prism" 
      $  "2015/5/30 Lens&Prism勉強会\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  header "Lensの限界" lensLimit
  header "Prismでパターンマッチ" prismPatternMuch
  header "Prismの合成" prismCoposition
  header "State上のPrism" prismWithState
  header "色々なFunctor" anyFunctor
  header "Lens, Optic, Prism" lens2Optic
  header "Opticで全体を見渡す" overlookWithOptic
  header "Prismの原理" prismDetail
  header "まとめ" summary
  --header "おまけ" aboutCategory

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
      ++ "　　　　　　-> Primsを使おう！"

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
      ++ "データコンストラクタを被せるGetterになる。\n"
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
  twinBottom
    ( parCont
      $  "Functorのイメージ：\n"
      ++ "　実用上の認識に囚われない方が良い。"
    )
    ( imgCont WStretch "../img/LensPrism/ufunctor.png" )
  twinBottom
    ( parCont
      $  "持ち上げ先の矢印を逆にする"
    )
    ( imgCont WStretch "../img/LensPrism/ucontravariant.png" )
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
  twinBottom
    ( parCont
      $  "２つの関数を一つに束ねる"
    )
    ( imgCont WStretch "../img/LensPrism/ubifunctor.png" )
  twinBottom
    ( parCont
      $  "Bifunctor"
    )
    ( codeCont
      $  "class Bifunctor f where\n"
      ++ "  bimap :: (a -> b) -> (c -> d) -> f a c -> f b d\n\n"
      ++ "  first :: (a -> b) -> f a c -> f b c\n"
      ++ "  first f = bimap f id\n\n"
      ++ "  second :: (b -> c) -> f a b -> f a c\n"
      ++ "  second f = bimap id f"
    )
  vertical
    [ parCont
      $  "Bifunctorの例：タプル、Const 等"
    , codeCont
      $  "instance Bifunctor (,)  where\n"
      ++ "  bimap f g (x, y) = (f x, g y)\n\n"
      ++ "instance Bifunctor Const  where\n"
      ++ "  bimap f _ (Const x) = Const $ f x"
    ]
  twinBottom
    ( parCont
      $  "Bifunctorの矢印を片方だけ反転"
    )
    ( imgCont WStretch "../img/LensPrism/uprofunctor.png" )
  twinBottom
    ( parCont
      $  "Profunctor"
    )
    ( codeCont
      $  "class Profunctor p where\n"
      ++ "  dimap :: (c -> a) -> (b -> d) -> p a b -> p c d\n\n"
      ++ "  lmap :: (a -> b) -> p b c -> p a c\n"
      ++ "  lmap f = dimap f id\n\n"
      ++ "  rmap :: (b -> c) -> p a b -> p a c\n"
      ++ "  rmap = dimap id\n"
    )
  twinBottom
    ( parCont
      $  "矢印で表せるような、合成可能な構造は、\n"
      ++ "Profunctorになり得る。"
    )
    ( imgCont WStretch "../img/LensPrism/uprofunctor2.png" )

--------
-- lens2Optic

lens2Optic :: Taka ()
lens2Optic = do 
  vertical
    [ parCont
      $  "Lensの定義を再掲"
    , codeCont
      $  "type Lens s t a b\n"
      ++ "  = forall f. Functor f => (a -> f b) -> s f t"
    ]
  vertical
    [ parCont
      $  "Functorの制約を外す"
    , codeCont
      $  "type LensLike f s t a b = (a -> f b) -> s -> f t"
    , parCont
      $  "これ以上の多相化は出来ない？"
    ]
  vertical
    [ takaCont
      $  "シンキング・タイム(10秒)"
    , codeCont
      $  "type LensLike f s t a b = (a -> f b) -> s -> f t"
    , parCont
      $  "まだ抽象化出来る？"
    ]
  vertical
    [ parCont
      $  "Haskellでは関数も型コンストラクタ"
    , codeCont
      $  "type LensLike f s t a b = (->) a (f b) -> (->) s (f t)\n"
      ++ "type Optic p f s t a b  = p    a (f b) -> p    s (f t)"
    , parCont
      $  "合成出来るように中央の(->)は残しておく"
    ]
  vertical
    [ parCont
      $  "Prismの定義"
    , codeCont
      $  "type Prism s t a b = forall p f. \n"
      ++ "  (Choice p, Applicative f) => p a (f b) -> p s (f t)"
    ]
  twinBottom
    ( parCont
      $  "Choice型クラス？\n"
      ++ "後でまた詳しく説明します。"
    )
    ( codeCont
      $  "class Profunctor p => Choice p where\n"
      ++ "  left' :: p a b -> p (Either a c) (Either b c)\n"
      ++ "  left' = dimap (either Right Left) (either Right Left) . right'\n\n"
      ++ "  right' :: p a b -> p (Either c a) (Either c b)\n"
      ++ "  right' = dimap (either Right Left) (either Right Left) . left'\n\n"
      ++ "instance Choice (->) where\n"
      ++ "  left' f (Left x) = Left $ f x\n"
      ++ "  left' _ (Right x) = Right x\n"
    )
  vertical
    [ parCont
      $  "LensもPrismもOpticで表現出来る。"
    , codeCont
      $  "type Lens s t a b\n"
      ++ "  = forall f. Functor f                   => Optic (->) f s t a b\n\n"
      ++ "type Prism s t a b \n"
      ++ "  = forall p f. (Choice p, Applicative f) => Optic p    f s t a b\n"
    ]
  vertical
    [ parCont
      $  "実際のlensライブラリでは、\n"
      ++ "Opticをさらに多相にしたOpticalも定義されている"
    , codeCont
      $  "type Optical p q f s t a b = p a (f b) -> q s (f t)\n"
      ++ "type Optic p f s t a b = Optical p p f s t a b"
    ]

--------
-- overlookWithOptic 

overlookWithOptic :: Taka ()
overlookWithOptic = do 
  vertical
    [ parCont
      $  "ekmett/lensのアクセサはすべて、\n"
      ++ "Optic型に属し、(.)で合成出来る"
    , codeCont
      $  "type Optic p f s t a b = p a (f b) -> p s (f t)"
    , parCont
      $  "pとfに様々な制約を与える事で\n"
      ++ "様々なアクセッサを、体系的に扱う。"
    ]
  list
    [ "Opticベースのlensなら・・・\n\n"
    , "合成について明示的に定義しなくて良い"
    , "lensモジュールに依存せずにアクセサを提供できる"
    , "Haskellの文法に適した記法が得られる"
    , "定式化／分析がしやすそう"
    , "恋人が出来る"
    , "お金持ちになれる"
    , "etc.. etc.."
    ]
  twinBottom
    ( parCont 
      $  "ekmett/lensに定義されている、\n"
      ++ "Lensの仲間をざっと見ていこう。"
    )
    ( imgCont WStretch "../img/LensPrism/ulensfrends.png")
  vertical
    [ parCont
      $  "Equalityは、\n"
      ++ "pとfに任意の型を取れるようにしたもの。\n"
      ++ "a=b, s=tを表す。（つまり何も変換出来ない）"
    , codeCont
      $  "type Equality s t a b = forall p f. )ptic p f s t a b\n"
      ++ "type Equality' s a = Equality s s a )\n\n"
      ++ "id :: Equality a b a b\n"
      ++ "   :: forall p f. p a (f b) -> p a (f b)\n"
    ]
  vertical
    [ parCont
      $  "同型を表すIsoは、以下のように定義される。"
    , codeCont
      $  "type Iso s t a b \n"
      ++ "  = forall p f. (Profunctor p, Functor f) => Optic p f s t a b\n"
      ++ "type Iso' s a = Iso s s a a"
    , parCont
      $  "s=a, t=bでGetterになるため\n"
      ++ "通常Iso'の方を使う事になる。"
    ]
  vertical
    [ parCont
      $  "iso関数を使えば簡単にIsoが作れるが、\n"
      ++ "変換が同型射である事は実装者が保証する。"
    , codeCont
      $  "iso :: (s -> a) -> (b -> t) -> Iso s t a b\n"
      ++ "iso f g = dimap f (fmap g)\n\n"
      ++ "boolMaybe :: Iso' Bool (Maybe ())\n"
      ++ "boolMaybe = iso bm mb\n"
      ++ "  where\n"
      ++ "   bm :: Bool -> Maybe ()\n"
      ++ "   mb :: Maybe () -> Bool"
    ]
  twinBottom
    ( parCont
      $  "from関数はIsoの向きを逆にする。\n"
      ++ "尚、ExchangeはProfunctor、IsoはAnIsoになる。"
    )
    ( codeCont
      $  "data Exchange a b s t = Exchange (s -> a) (b -> t)\n"
      ++ "instance Profunctor (Exchange a b) where\n"
      ++ "  dimap f g (Exchange h i) = Exchange (h . f) (g . i)\n\n"
      ++ "type AnIso s t a b = Optic (Exchange a b) Identity s t a b\n\n"
      ++ "from :: AnIso s t a b -> Iso b a t s\n"
    )
  vertical
    [ parCont
      $  "IsoをGetterとして使う例。\n"
      ++ "もちろん、問題なくSetterにもなる。"
    , codeCont
      $  "(True, 10)^._1.boolMaybe         -- Just ()\n"
      ++ "(False, 10)^._1.boolMaybe        -- Nothing\n"
      ++ "(Just (), 10)^._1.from boolMaybe -- True\n"
      ++ "(Nothing, 10)^._1.from boolMaybe -- False"
    ]
  vertical
    [ parCont
      $  "Isoのp::Profunctorを(->)に固定するとLens。\n"
      ++ "p::ProfunctorをChoiceにし、\n"
      ++ "f::FunctorをApplicativeにすればPrismになる。"
    , codeCont
      $  "type Lens s t a b\n"
      ++ "  = forall f. Functor f                   => Optic (->) f s t a b\n\n"
      ++ "type Prism s t a b \n"
      ++ "  = forall p f. (Choice p, Applicative f) => Optic p    f s t a b\n"
    ]
  vertical
    [ parCont
      $  "Prismから、a=t, f=bとして、\n"
      ++ "pにBifunctor制約を追加、fの制約をSettableに"
    , codeCont
      $  "type Review t b = forall p f. \n"
      ++ "  (Choice p, Bifunctor p, Settable f) => Optic p f t t b b"
    , parCont
      $  "尚、Settableは要Functor（後述）なので、\n"
      ++ "PrismはReviewになる。"
    ]
  vertical
    [ parCont
      $  "TaggedはChoiceでありBifunctor\n"
      ++ "かつIdentityはSettableなので、\n"
      ++ "ReviewはAReviewになる、PrismもAReview"
    , codeCont
      $  "newtype Tagged t a = ... \n"
      ++ "instance Bifunctor Tagged where\n"
      ++ "instance Choice Tagged where\n"
      ++ "instance Settable Identity where\n\n"
      ++ "type AReview t b = Optic' Tagged Identity t b\n"
    ]
  vertical
    [ parCont
      $  "Reviewを扱う関数。\n"
      ++ "可能な限り多相化されてるのでわかりづらい。"
    , codeCont
      $  "unto :: (Profunctor p, Bifunctor p, Functor f) \n"
      ++ "    => (b -> t) -> Optic p f s t a b\n"
      ++ "un :: (Profunctor p, Bifunctor p, Functor f) \n"
      ++ "    => Getting a s a -> Optic p f a a s s\n"
      ++ "re :: Contravariant f => AReview t b -> LensLike f b b t t"
    ]
  vertical
    [ parCont
      $  "だいたいこんな感じ"
    , codeCont
      $  "unto :: (b -> t) -> Review s t a b\n"
      ++ "un :: Getter s a -> Review a a s s\n"
      ++ "re :: Review t t b b -> Getter b t"
    , parCont
      $  "re関数でGetterに出来る。\n"
      ++ "てか、Getterにしないと何もできない。"
    ]
  vertical
    [ parCont
      $  "やたら多相化されてるGetting/Getter"
    , codeCont
      $  "type Getting r s a = Optic (->) (Const r) s s a a \n"
      ++ "type Getter s a = forall f. \n"
      ++ "    (Functor f, Contravariant f) => Optic (->) f s s a a"
    , parCont
      $  "Const r は Contravariant（後述）なので、\n"
      ++ "GettingはGetterになる。"
    ]
  vertical
    [ parCont
      $  "SetterはIdentityが多相化されていて、\n"
      ++ "Settable型クラスになっている。"
    , codeCont
      $  "type Setter s t a b \n"
      ++ "  = forall f. Settable f => Optic (->) f s t a b"
    ]
  vertical
    [ parCont
      $  "a=t, f=b に固定、"
      ++ "fがContravariantかつApplicative"
    , codeCont
      $  "type Fold s a = forall f. \n"
      ++ "    (Contravariant f, Applicative f) => Optic (->) f s s a a"
    , parCont
      $  "Getter, Traversalの制約を強くしたもの、\n"
      ++ "当然、LensもPrismもFoldになる。"
    ]
  vertical
    [ parCont
      $  "以下の２つの演算子はFoldのためのもの。\n"
      ++ "（(^..)の説明は割愛。）\n"
    , codeCont
      $  "(^..) :: s -> Getting (Endo [a]) s a -> [a]\n"
      ++ "(^?) :: s -> Getting (First a) s a -> Maybe a"
    , parCont
      $  "Getting r s a の r に指定する型がモノイドなら\n"
      ++ "その型はFoldになる（後述）"
    ]

--------
-- overlookWithOptic 

prismDetail :: Taka ()
prismDetail = do
  list
    [ "lensライブラリは巨大＆複雑"
    , "すべての機能を把握するのは超大変"
    , "よく使うところから少しづつ掘り下げていこう" , "今回はPrism周りの仕組みを解説"
    ]
  twinBottom
    ( parCont
      $  "まずは、ChoiceとPrismを再掲"
    )
    ( codeCont
      $  "class Profunctor p => Choice p where\n"
      ++ "  left' :: p a b -> p (Either a c) (Either b c)\n"
      ++ "  left' = dimap (either Right Left) (either Right Left) . right'\n\n"
      ++ "  right' :: p a b -> p (Either c a) (Either c b)\n"
      ++ "  right' = dimap (either Right Left) (either Right Left) . left'\n\n"
      ++ "type Prism s t a b = forall p f. \n"
      ++ "    (Choice p, Applicative f) => Optic p f s t a b"
    )
  vertical
    [ parCont
      $  "Choiceの二大インスタンス\n"
      ++ "その１：関数"
    , codeCont
      $  "instance Choice (->) where\n"
      ++ "  left' f (Left x) = Left $ f x\n"
      ++ "  left' _ (Right x) = Right x"
    ]
  vertical
    [ parCont
      $  "Choiceの二大インスタンス\n"
      ++ "その２：Tagged" 
    , codeCont
      $  "newtype Tagged t a = Tagged { unTagged :: a } \n\n"
      ++ "instance Bifunctor Tagged where\n"
      ++ "  bimap _ f = Tagged . f . unTagged\n"
      ++ "instance Profunctor Tagged where\n"
      ++ "  dimap _ f = Tagged . f . unTagged\n"
      ++ "instance Choice Tagged where\n"
      ++ "  right' = Tagged . Right . unTagged"
    ]
  twinBottom
    ( parCont
      $  "ChoiceはProfunctorに別の変換を与える。\n"
      ++ "ちなみに、足し算はEitherを表す（圏論の慣習）"
    )
    ( imgCont WStretch "../img/LensPrism/uchoice.png" )
  vertical
    [ parCont
      $  "Prismを作るためのprism関数\n"
      ++ "dimapとright\'で順同型射からPrismを作れる"
    , codeCont
      $  "prism :: (b -> t) -> (s -> Either t a) -> Prism s t a b\n"
      ++ "prism bt seta = dimap seta (either pure $ fmap bt) . right'\n\n"
      ++ "_Just :: Prism (Maybe a) (Maybe b) a b\n"
      ++ "_Just = prism Just $ \\case\n"
      ++ "  Just x -> Right x\n"
      ++ "  Nothing -> Left $ Nothing\n"
    ]
  vertical
    [ parCont
      $  "Setterの場合、over関数のタイミングで、\n"
      ++ "Optic p f s t a b の f が Identityに固定される"
    , codeCont
      $  "over :: Setter s t a b -> (a -> b) -> s -> t\n"
      ++ "over l f = getIdentity . l (Identity . f)\n\n"
      ++ "set :: Setter s t a b -> b -> s -> t\n"
      ++ "set a = over a . const\n\n"
      ++ "(.~) = set\n"
    ]
  vertical
    [ parCont
      $  "改めて、Setterの型と比較。"
    , codeCont
      $  "type Setter s t a b \n"
      ++ "  = forall f. Settable f => Optic (->) f s t a b\n"
      ++ "type Prism s t a b = forall p f. \n"
      ++ "    (Choice p, Applicative f) => Optic p f s t a b"
    , parCont
      $  "関数はChoiceのインスタンスなので問題なし\n"
      ++ "Settableってなんだ。"
    ]
  vertical
    [ parCont
      $  "実はよくわかってない(´・ω・｀)\n\n"
      ++ "けどIdentityはSettableのインスタンスなので、\n"
      ++ "pureとuntaintedがあればover相当の関数は作れるはず。"
    , codeCont
      $  "class Functor g => Distributive g where\n"
      ++ "  distribute :: Functor f => f (g a) -> g (f a)\n"
      ++ "class (Applicative f\n"
      ++ "  , Distributive f, Traversable f) => Settable f where\n"
      ++ "  untainted :: f a -> a\n\n"
      ++ "instance Settable Identity where\n"
      ++ "  untainted = getIdentity"
    ]
  twinBottom
    ( parCont
      $  "Prismアクセッサの動作を簡単にチェックしたい。\n"
      ++ "次のような型を作ってみよう。"
    )
    ( codeCont
      $  "data Hoge = Foo String | Bar Int | Buz String deriving Show\n\n"
      ++ "_Foo :: Prism Hoge Hoge String String\n"
      ++ "_Foo = prism Foo $ \\case\n"
      ++ "  Foo s -> Right s\n"
      ++ "  x -> Left x\n\n"
      ++ "_Bar :: Prism Hoge Hoge Int Int\n"
      ++ "_Buz :: Prism Hoge Hoge String String\n"
    )
  vertical
    [ parCont
      $  "f を Identityに固定する事で、\n"
      ++ "パターンにマッチした場合のみmap出来る事を、\n"
      ++ "次のようにして確認できる。"
    , codeCont
      $  "ghci> getIdentity . _Foo (Identity . (++\"Piyo\")) $ Foo \"Hoge\"\n"
      ++ "Foo \"HogePiyo\"\n"
      ++ "ghci> getIdentity . _Foo (Identity . (++\"Piyo\")) $ Bar 114514\n"
      ++ "Bar 114514\n"
      ++ "ghci> getIdentity . _Foo (Identity . (++\"Piyo\")) $ Buz \"Hoge\"\n"
      ++ "Buz \"Hoge\"\n"
    ]
  twinBottom
    ( parCont
      $  "以下のように図に描くとわかりやすい。\n"
      ++ "profunctor や f の型を固定して考えてみよう。"
    )
    ( imgCont WStretch "../img/LensPrism/uprism.png" )
  twinBottom
    ( parCont
      $  "Getterとして使う場合\n"
      ++ "Const r は Applicativeでない事に注意"
    )
    ( codeCont
      $  "type Prism s t a b = \n"
      ++ "    forall p f. (Choice p, Applicative f) => Optic p f s t a b\n\n"
      ++ "type Getting r s a = Optic' (->) (Const r) s a \n\n"
      ++ "foldOf :: Getting a s a -> s -> a\n"
      ++ "foldOf l = getConst . l Const\n\n"
      ++ "(^.) = flip foldOf\n"
    )
  vertical
    [ parCont
      $  "ただし、Gettingのrがモノイドの場合に限り、\n"
      ++ "Const rがApplicativeになる。"
    , codeCont
      $  "type Getting r s a = Optic' (->) (Const r) s a \n\n"
      ++ "instance Monoid m => Applicative (Const m) where\n"
      ++ "  pure x = Const mempty\n"
      ++ "  (<*>) _ = Const . getConst"
    ]
  vertical
    [ parCont
      $  "prism関数の定義を再掲"
    , codeCont
      $  "prism :: (b -> t) -> (s -> Either t a) -> Prism s t a b\n"
      ++ "prism bt seta = dimap seta (either pure $ fmap bt) . right'\n\n"
    , parCont
      $  "マッチング出来ない場合は、\n"
      ++ "pureの部分でmemptyが取得される。"
    ]
  vertical
    [ parCont
      $  "Foldとして使う場合\n"
      ++ "ConstはContravariantになるので、\n"
      ++ "あとはFirst aがモノイドであればFoldになりそう。"
    , codeCont
      $  "type Fold s a = forall f. \n"
      ++ "    (Contravariant f, Applicative f) => Optic' (->) f s a\n"
      ++ "type Getting r s a = Optic' (->) (Const r) s a \n\n"
      ++ "(^?) :: s -> Getting (First a) s a -> Maybe a\n"
    ]
  vertical
    [ parCont
      $  "FirstはMaybeと同型、\n"
      ++ "MaybeはMonoidになる。"
    , codeCont
      $  "newtype First a = First { getFirst :: Maybe a }\n\n"
      ++ "instance Monoid (First a) where\n"
      ++ "  mempty = First Nothing\n"
      ++ "  r@(First (Just )) `mappend` _  = r\n"
      ++ "  First Nothing `mappend` r = r\n"
    ]
  vertical
    [ parCont
      $  "後はだいたいGetterの理屈と一緒\n"
      ++ "AccessingはGettingの変形"
    , codeCont
      $  "type Accessing p m s a = Optical p (->) (Const m) s s a a\n\n"
      ++ "foldMapOf :: Profunctor p => Accessing p r s a -> p a r -> s -> r\n"
      ++ "foldMapOf l f = getConst . l (Const #. f)\n\n"
      ++ "(^?) :: s -> Getting (First a) s a -> Maybe a\n"
      ++ "s ^? l = getFirst $ foldMapOf l (First #. Just) s\n"
    ]
  vertical
    [ parCont
      $  "re関数の実装、ようやくTagged登場\n"
      ++ "TaggedはChoice、IdentityはApplicativeの、\n"
      ++ "それぞれインスタンスなのでPrismはAReview"
    , codeCont
      $  "re :: Contravariant f => AReview t b -> LensLike f b b t t\n"
      ++ "re p = to (getIdentity #. unTagged #. p .# Tagged .# Identity)\n\n"
      ++ "newtype Tagged t a = Tagged { unTagged :: a }\n"
      ++ "type AReview t b = Optic' Tagged Identity t b\n"
    ]
  twinBottom
    ( parCont
      $  "prismの図を再掲、\n"
      ++ "re関数の動作原理を考えてみよう。"
    )
    ( imgCont WStretch "../img/LensPrism/uprism.png" )
  vertical
    [ parCont
      $  "直接コンストラクタを被せるのは、\n"
      ++ "簡単に試す事ができる。\n\n"
      ++ "純粋な関数になれば、to関数でGetterに出来る。"
    , codeCont
      $  "ghci> :t _Just $ Tagged (Identity 10)\n"
      ++ "_Just $ Tagged (Identity 10)\n"
      ++ "  :: Num b => Tagged (Maybe a) (Identity (Maybe b))\n"
      ++ "ghci> getIdentity . unTagged . _Just $ Tagged (Identity 10)\n"
      ++ "Just 10\n"
      ++ "ghci> getIdentity . unTagged . _Foo $ Tagged (Identity \"Hoge\")\n"
      ++ "Foo \"Hoge\"\n"
    ]
  twinBottom
    ( parCont
      $  "reの実装は関数合成でも同じはず\n"
      ++ "(´・ω・｀)あれ？"
    )
    ( codeCont
      $  "--これでも良いはず\n"
      ++ "re :: Contravariant f => AReview t b -> LensLike f b b t t\n"
      ++ "re p = to (getIdentity . unTagged . p . Tagged . Identity)\n\n"
      ++ "--実際\n"
      ++ "re :: Contravariant f => AReview t b -> LensLike f b b t t\n"
      ++ "re p = to (getIdentity #. unTagged #. p .# Tagged .# Identity)\n"
      ++ "--                     ^           ^     ^         ^\n"
      ++ "--                     why profunctor??"
    )
  twinBottom
    ( parCont
      $  "Prismはただ単に順同型を表すので、\n"
      ++ "パターンマッチの用途に囚われず使える。"
    ) 
    ( codeCont
      $  "nat :: Prism' Integer Natural\n"
      ++ "nat = prism toInteger \n"
      ++ "  $ \\i -> if i < 0 then Left i else Right (fromInteger i)\n\n"
      ++ "5^?nat                   -- Just 5  :: Maybe Natural\n"
      ++ "(-5)^?nat                -- Nothing :: Maybe Natural\n"
      ++ "(10 :: Natural)^.re nat  -- 10      :: Integer"
    )

--------
-- summary

summary :: Taka ()
summary = do
  list
    [ "Lensは便利"
    , "でも直和型には弱い"
    , "そんな時にはPrism！"
    , "LensもPrismもOpticで表せるよ"
    , "Opticでekmett/lens全体を見渡せる"
    , "Prismの原理を覗いてみたよ"
    , "Lens/Prismちょーすげぇ！"
    ]
  taka "てなわけで"
  taka "みんな\nLensを使おう！"

--------
-- aboutCategory

aboutCategory :: Taka ()
aboutCategory = do
  return ()

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

