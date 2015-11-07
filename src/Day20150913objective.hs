module Day20150913objective where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20150913objective :: IO ()
day20150913objective = do
  let fileName = "contents/day20150913objective.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions

  stateSandbox $ do  
    title "Haskellでオブジェクト指向"
      $  "2015/9/13 関数プログラミング交流会\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  profile

  header "そもそもの話" toBeginWith
  header "モナドと手続き" monadAndProgress
  header "オブジェクトの定義" functorAndNaturalTrans
  header "メッセージ\nメソッドと手続き" methodAndProgress
  header "オブジェクトの拡張" objectExtension
  --header "圏論とオブジェクト設計" categoryAndOOP
  --header "まとめ" $ return ()
  
  slideTitle .= ""
  par 
    $  "残り資料間に合わない感じなので\n"
    ++ "アドリブで頑張る\n\n"
    ++ "①オブジェクトを射とした圏の話\n"
    ++ "②寿命のあるオブジェクト／ストリーム操作\n"
  taka "ありがとうございました\nm(__)m"

-------------------------------------------------
-- toBeginWith

toBeginWith :: Taka ()
toBeginWith = do
  slideTitle .= "Haskellという言語"
  bigList
    [ "純粋だとか"
    , "ラムダ計算だとか"
    , "型システムだとか"
    , "圏論的にはどーだとか\n\n"
    , "こ難しい事はさておき・・・"
    ]
  taka "まぁ\nとにかくすごい"
  slideTitle .= "Haskellと状態"
  bigList
    [ "Haskellはすごい"
    , "でも状態を扱うのは苦手？"
    , "そこでモナドですよ！\n\n"
    , "モナドとか良くわからん(´・ω・｀)"
    ]
  slideTitle .= "モナドは手続き"
  big 
    $  "「たまたま」モナドという数学上の概念が\n"
    ++ "手続きプログラミングに「欲しい」性質を\n"
    ++ "持っているのでそれを応用しているだけ。\n\n"
    ++ "詳しくは後述"
  bigList
    [ "Haskellで状態を扱える"
    , "スコープの制御も自由自在"
    , "実態はただのデータ構造"
    , "→つまり手続きがファーストクラス！"
    , "→しかも多相！！！"
    ]
  taka "モナドすげぇ！"
  slideTitle .= "何が問題？"
  bigList 
    [ "ゲームの仕掛けやキャラクター"
    , "GUIのコンポーネント"
    , "音／絵など副作用の制御構造"
    , "とかとか\n\n"
    , "オブジェクトが有効なシーンも無くはない"
    ]
  slideTitle .= "オブジェクト指向(OOP)とは"
  bigList 
    [ "モノとモノが云々"
    , "メッセージがメソッドが"
    , "継承関係がどーとかこーとか"
    , "動物クラスに猫クラス"
    , "アラン・ケイがなんたら"
    , "ストラウストラップがどうたら"
    ]
  taka "なるほどわからん\n(´・ω・｀)"
  slideTitle .= "実際の所"
  bigList 
    [ "プログラマの数だけOOPがある"
    , "歴史/本質の話は数あれど・・・"
    , "何か共通のコンテクストはある？\n\n"
    , "下手なこと言うと論争になるよねorz"
    ]
  taka "よし\n不毛な話はやめよう"
  slideTitle .= "OOPLにありがちな機能"
  bigList 
    [ "クラスとインスタンス"
    , "メソッド呼び出し"
    , "手続き／制御構造"
    , "抽象クラスと継承"
    , "インターフェイスと実装\n\n"
    , "・・・ってあれ？"
    ]
  taka 
    $  "オブジェクト指向に\n"
    ++ "必要なものって\n"
    ++ "やったら多くね？"
  slideTitle .= "今日やる事"
  big 
    $  "\n\n我々が「欲しい」と考える\n"
    ++ "OOPLの機能を得るための\n"
    ++ "Haskellらしい仕組みを考える"

-------------------------------------------------
-- monadAndProgress

monadAndProgress :: Taka ()
monadAndProgress = do
  slideTitle .= "Haskellらしい仕組み？"
  big 
    $  "\n\nまず、手続きを導入する手段として、\n"
    ++ "モナドがもてはやされている理由について、\n"
    ++ "考えてみよう。"
  slideTitle .= "Why Monad is best"
  bigList
    [ "多相だから？←まぁあってる"
    , "ファーストクラスだから？←ちげぇねぇ"
    , "シンプルだから？←異論ありそう"
    , "数学的だから？←注目！！！"
    ]
  par 
    $  "\n\n「数学」という言葉を使うとまた荒れそうなので\n"
    ++ "「形式的」という言葉に言い換えます\n\n"
    ++ "ここでいう「形式的」は\n"
    ++ "「簡単な定義の組み合わせで曖昧性／矛盾なく説明できる」\n"
    ++ "くらいの意味です"
  slideTitle .= "皆様"
  taka "突然ですが、\n手続きプログラミングを\n説明できますか？"
  taka "そもそも"
  taka "「手続き」って\n何なんすか(´・ω・｀)"
  slideTitle .= "Haskellの上の手続き"
  twinBottom
    ( parCont
      $  "Haskell上では普通に、\n"
      ++ "手続きプログラミングが出来る。"
    )
    ( codeCont
      $  "main :: IO ()\n"
      ++ "main = do\n"
      ++ "  putStrLn \"ファーストネームを入力してね\"\n"
      ++ "  firstName <- getLine\n"
      ++ "  putStrLn \"ラストネームを入力してね\"\n"
      ++ "  lastName <- getLine\n"
      ++ "  let name = firstName ++ \" \" ++ lastName\n"
      ++ "  putStrLn $ \"こんにちは、\" ++ name ++ \"さん。\"\n"
    )
  twinBottom
    ( parCont 
      $  "手続き自体がプリミティブな機能というワケでは無い\n"
      ++ "モナドによって実現されている。"
    )
    ( codeCont
      $  "class Monad m where\n"
      ++ "  (>>=)   :: m a -> (a -> m b) -> m b\n"
      ++ "  return  :: a -> m a\n\n"
      ++ "-- モナド則\n"
      ++ "return x >>= f == f x\n"
      ++ "m >>= return == m\n"
      ++ "(m >>= f) >>= g == m >>= (\\x -> f x >>= g)\n"
    )
  twinBottom
    ( parCont
      $  "先のコードは以下のような\n"
      ++ "純粋な関数の構文糖になっている。"
    )
    ( codeCont
      $  "main :: IO ()\n"
      ++ "main = \n"
      ++ "  putStrLn \"ファーストネームを入力してね\" >>\n"
      ++ "  getLine >>= \\firstName ->\n"
      ++ "  putStrLn \"ラストネームを入力してね\" >>\n"
      ++ "  getLine >>= \\lastName ->\n"
      ++ "  let name = firstName ++ \" \" ++ lastName in\n"
      ++ "  putStrLn (\"こんにちは、\" ++ name ++ \"さん。\")\n"
    )
  slideTitle .= "手続きとは"
  big
    $  "そもそも手続きとは何か、\n"
    ++ "改めて整理しよう。"
  vertical
    [ parCont
      $  "①手続きは命令を並べたもの\n"
      ++ "命令は次の命令に影響を与えるかもしれない。"
    , codeCont
      $  "Aする\n"
      ++ "Bする\n"
      ++ "Cする"
    ]
  vertical
    [ parCont
      $  "②各命令は引数を取るかもしれない。\n"
      ++ "各命令は値を返すかもしれない。"
    , codeCont
      $  "Aする 引数\n"
      ++ "返却値 = Bした結果\n"
      ++ "Cする 返却値"
    ]
  vertical
    [ parCont
      $  "③「何もしない」命令も存在する。"
    , codeCont
      $  "Aする\n"
      ++ "Bする\n"
      ++ "サボる\n"
      ++ "Cする"
    ]
  vertical
    [ parCont
      $  "④「何もしない」命令は、\n"
      ++ "書かなくても結果に影響は無い。"
    , codeCont
      $  "Aしてサボる = Aする\n"
      ++ "サボってからAする = Aする"
    ]
  twinBottom
    ( parCont
      $  "⑤命令を大きな命令にまとめた時、\n"
      ++ "どんな塊でまとめても結果には影響ない。"
    )
    ( codeCont
      $  "AしてBする\n"
      ++ "Cする\n\n"
      ++ "も\n\n"
      ++ "Aする\n"
      ++ "BしてCする\n\n"
      ++ "も一緒"
    )
  big
    $  "以上を「手続きの要件」と定義すれば、\n"
    ++ "天下り的ですが、違和感は無いでしょう。\n\n"
    ++ "すると（トートロジーですが）この定義は、\n"
    ++ "モナドの定義と完全に一致するのです。"
  slideTitle .= "型に置き換えてみる"
  vertical
    [ parCont
      $  "①手続きは命令を並べたもの\n"
      ++ "命令は次の命令に影響を与えるかもしれない。\n"
      ++ "②各命令は引数を取るかもしれない。\n"
      ++ "各命令は値を返すかもしれない。"
    , codeCont
      $  "-- 命令を\n"
      ++ "a -> m b\n"
      ++ "-- とすると、a が引数 b が返り値、mが次の命令に与える影響となる\n"
      ++ "(>>=) :: m a -> (a -> m b) -> m b\n"
      ++ "-- とすると、\n"
      ++ "Aした結果 >>= Bする :: Bした結果\n"
      ++ "-- となり、どんどん並べる事ができる。"
    ]
  vertical
    [ parCont
      $  "①手続きは命令を並べたもの\n"
      ++ "命令は次の命令に影響を与えるかもしれない。\n"
      ++ "②各命令は引数を取るかもしれない。\n"
      ++ "各命令は値を返すかもしれない。"
    , parCont2
      $  "引数がいらない場合は、\n"
      ++ "受け取った引数を捨ててしまえば良い。\n"
      ++ "返却値がいらない場合は、\n"
      ++ "意味の無いUnit型の値を返せば良い。"
    ]
  vertical
    [ parCont
      $  "③「何もしない」命令も存在する。\n"
      ++ "④「何もしない」命令は、\n"
      ++ "書かなくても結果に影響は無い。"
    , codeCont
      $  "return :: a -> m a\n"
      ++ "--を何もしない命令とする。\n\n"
      ++ "--モナド則\n"
      ++ "return x >>= f == f x および m >>= return == m\n"
      ++ "--により、returnは何もしてはいけない\n"
    ]
  vertical
    [ parCont
      $  "⑤命令を大きな命令にまとめた時、\n"
      ++ "どんな塊でまとめても結果には影響ない。"
    , codeCont
      $  "-- モナド則\n"
      ++ "(m >>= f) >>= g == m >>= (\\x -> f x >>= g)\n"
    ]
  taka "完全に一致"
  slideTitle .= "もう一つのモナドの定義"
  vertical
    [ parCont 
      $  "(>>=)を使ってjoin関数を実装できる。\n" 
      ++ "joinとfmapで(>>=)を実装できる。" 
    , codeCont
      $  "join :: Monad m => m (m a) -> m a\n"
      ++ "join x = x >>= id\n\n"
      ++ "(>>=) :: Monad m => m a -> (a -> m b) -> m b\n"
      ++ "x >>= f = join (fmap f x)"
    ]
  twinBottom
    ( parCont 
      $  "Monadは次のように定義しても意味は変わらない。\n" 
      ++ "証明も可能だが今回は割愛。" 
    )
    ( codeCont
      $  "class Functor m => Monad m where\n"
      ++ "  join :: m (m a) -> m a\n"
      ++ "  return :: a -> m a\n\n"
      ++ "--モナド則\n"
      ++ "join . fmap join = join . join\n"
      ++ "join . fmap return = join . return = id\n"
      ++ "return . f = fmap f . return\n"
      ++ "join . fmap (fmap f) = fmap f . join"
    )
  slideTitle .= "モナドの定義は形式的"
  big
    $  "①何か型をつくる\n"
    ++ "②Monadクラスのインスタンスにする\n"
    ++ "③ちゃんとモナド則を満たす事を確認する\n"
    ++ "④その型は例外なくモナドです"
  big 
    $  "\n\nこう言い切ってしまえば、\n"
    ++ "「モナドとは何か」なんて議論する余地は、\n"
    ++ "本来無いはずなのですよっ(｀・ω・´)"
  slideTitle .= "とにかく"
  taka "「モナド」とは唯一\n手続きを形式的に説明する事に\n成功した概念である"
  par "たぶん"
  slideTitle .= "ちなみに"
  par
    $  "型の性質について議論するにあたり、\n"
    ++ "「実装されている事」と「実装可能な事」の間に\n" 
    ++ "根本的な違いは無い。例えば・・・\n\n" 
    ++ "何かデータ型を定義した時、そのデータ構造に対して\n" 
    ++ "モナド即を満たすインスタンスを「実装可能」ならば\n" 
    ++ "そのデータ型をモナドであるとしても差し支えない。" 
  slideTitle .= "形式的である事の強み"
  par
    $  "【論争を産まない】\n"
    ++ "実情として、「モナドとは何か」という議論は、\n"
    ++ "常に学習者に対する説明の試行錯誤として行われている\n"
    ++ "(識者にとっては自明過ぎてむしろ説明が難しい)\n\n"
    ++ "【研究しやすい】\n"
    ++ "それが何であるか明確なため、\n"
    ++ "対象が持つ性質を探るのが容易\n"
  par
    $  "【応用しやすい】\n"
    ++ "よく性質の知られた概念であれば、\n"
    ++ "その性質を利用した大胆な応用も容易い\n\n"
    ++ "【語彙が増える】\n"
    ++ "よく形式化された語彙を共有する事により\n" 
    ++ "さらに複雑な概念を簡潔かつ正確に\n" 
    ++ "説明する事ができるようになる" 
  slideTitle .= "何が言いたいのか"
  big
    $  "OOPとは何かという議論は必要無い\n\n"
    ++ "ひと通りの有用なOOPの機能を実現するために\n"
    ++ "形式的でエレガントな\n"
    ++ "最小限の定義を考える事が、\n"
    ++ "「Haskellらしい」OOPである"

-------------------------------------------------
-- functorAndNaturalTrans

functorAndNaturalTrans :: Taka ()
functorAndNaturalTrans = do
  slideTitle .= "圏論"
  vertical
    [ parCont 
      $  "頂点A, B, Cを「対象(Object)」と呼ぶ。\n" 
      ++ "下の図の、矢印f, gを「射(Arrow)」と呼ぶ。" 
    , codeCont 
      $  "     f         g\n"
      ++ "A ------> B ------> C"
    ]
  vertical
    [ parCont 
      $  "射は合成する事が出来る。" 
    , codeCont 
      $  "         g○f\n"
      ++ "+-------------------+\n"
      ++ "|                   |\n"
      ++ "|   f          g    v\n"
      ++ "A ------> B ------> C\n"
    ]
  vertical
    [ parCont 
      $  "射には恒等射が存在する。" 
    , codeCont 
      $  "     Id_A\n"
      ++ " +---------+\n"
      ++ " |         |\n"
      ++ " |         |\n"
      ++ " A <------ +"
    ]
  twinBottom
    ( parCont
      $  "射は結合則を満たす。\n" 
      ++ "AからDへのどのルートを辿っても全て等価。" 
    )
    ( codeCont
      $  "         g○f\n"
      ++ "+-------------------+\n"
      ++ "|                   |\n"
      ++ "|   f          g    v    h\n"
      ++ "A ------> B ------> C ------> D\n"
      ++ "          |                   ^\n"
      ++ "          |                   |\n"
      ++ "          +-------------------+\n"
      ++ "                   h○g\n"
    )
  twinBottom
    ( parCont
      $  "恒等射は、" 
      ++ "AからBどのルートを辿ってもfと等価。" 
    )
    ( codeCont
      $  "                        Id_B\n"
      ++ "                    + ------- +\n"
      ++ "                    |         |\n"
      ++ "               f    |         |\n"
      ++ "+ ------> A ------> B <------ +\n"
      ++ "|         |\n"
      ++ "|         |\n"
      ++ "+ ------- +\n"
      ++ "   Id_A\n"
    )
  vertical
    [ listCont
      [ "型が対象"
      , "関数が射"
      , "関数合成が射の合成"
      , "id関数が恒等射"
      ]
    , parCont
      $  "のように当てはめる事で、\n"
      ++ "関数プログラミングの型は圏になる。"
    ]
  slideTitle .= "自己関手"
  vertical
    [ parCont
      $  "関手は圏から圏への変換\n"
      ++ "ある圏から同じ圏への関手を自己関手と呼ぶ\n\n"
      ++ "HaskellのFunctorは型の圏から型の圏への自己関手"
    , codeCont 
      $  "class Functor f where\n"
      ++ "  fmap :: (a -> b) -> f a -> f b\n\n"
      ++ "--Functor則\n"
      ++ "fmap id == id\n"
      ++ "fmap (g.f) == fmap g . fmap f\n"
    ]
  vertical
    [ parCont
      $  "よーわからんよねー(´・ω・｀)\n\n"
      ++ "とにかくあれ、モナドの時と同じようにfmapが定義できて、\n"
      ++ "Functor則を満たせば良いんです。"
    , codeCont 
      $  "class Functor f where\n"
      ++ "  fmap :: (a -> b) -> f a -> f b\n\n"
      ++ "--Functor則\n"
      ++ "fmap id == id\n"
      ++ "fmap (g.f) == fmap g . fmap f\n"
    ]
  slideTitle .= "自然変換"
  vertical
    [ parCont
      $  "自然変換は関手から関手への変換\n\n"
      ++ "Haskellにおける自然変換とは、mとnを任意の関手とした時に\n"
      ++ "「自然性」と呼ばれる規則を満たす関数natの事"
    , codeCont 
      $  "nat :: m a -> n a\n\n"
      ++ "--自然性\n"
      ++ "nat . fmap f == fmap f . nat" 
    ]
  twinBottom
    ( parCont
      $  "自然性は以下のような図で考えると良い"
    )
    ( codeCont 
      $  "       nat\n"
      ++ "F A --------> G A\n"
      ++ " |             |\n"
      ++ " | fmap f      |  fmap f\n"
      ++ " |             |\n"
      ++ " v     nat     v\n"
      ++ "F B --------> G B\n"
    )
  slideTitle .= "ミーリ・マシン"
  vertical
    [ parCont
      $  "入力aを受けると出力bを返し、\n"
      ++ "自身の状態を書き換えるオートマトンの一種。"
    , codeCont 
      $  "newtype Mealy a b = Mealy\n"
      ++ "  { runMealy :: a -> (b, Mealy a b) }\n"
    ]
  twinBottom
    ( parCont
      $  "以下のような演算子とサンプルの実装を用意すれば"
    )
    ( codeCont 
      $  "(.!) :: MVar (Mealy a b) -> a -> IO b\n"
      ++ "m .! i = modifyMVar m $ \\o -> do\n"
      ++ "   (res, next) <- return $ runMealy o i\n"
      ++ "   return (next, res)\n\n"
      ++ "strBuffer :: Mealy String (Int, String) \n"
      ++ "strBuffer = f (0, \"\")\n"
      ++ "  where\n"
      ++ "    f :: (Int, String) -> Mealy String (Int, String)\n"
      ++ "    f (i, s) = Mealy $ \\t -> let n = (i + 1, s ++ t) in (n, f n)"
    )
  twinBottom
    ( parCont
      $  "IO上で状態が書き換えられてく様を確認出来る"
    )
    ( codeCont 
      $  "sample :: IO ()\n"
      ++ "sample = do\n"
      ++ "  inst <- newMVar strBuffer\n"
      ++ "  res <- inst .! \"Hoge\"\n"
      ++ "  print res -- (1, \"Hoge\")\n"
      ++ "  res <- inst .! \"Piyo\"\n"
      ++ "  print res -- (2, \"HogePiyo\")\n"
      ++ "  res <- inst .! \"Fuga\"\n"
      ++ "  print res -- (3, \"HogePiyoFuga\")\n"
    )
  slideTitle .= "ちょっと復習"
  twinTop
    ( listCont
      [ "モナド：手続きを実現する形式的な構造"
      , "すべてのモナドはFunctor(関手)でもある"
      , "関手：Functor則を満たすfmapが実装出来る"
      , "自然変換：関手から関手への変換、自然性を満たす"
      , "ミーリマシン：入力／出力を返し自身の状態を持つ"
      ]
    )
    ( parCont 
      $  "これらの道具立てで\n"
      ++ "OOPの機能を形式的に実現できないだろうか"
    )
  slideTitle .= "オブジェクトを表す型"
  vertical
    [ parCont
      $  "@fumievalさんによる、\n"
      ++ "HaskellでOOPを実現するライブラリによる定義"
    , codeCont
      $  "newtype Object f g \n"
      ++ "  = Object { runObject :: forall x. f x -> g (x, Object f g) }"
    ] 
  twinBottom
    ( parCont 
      $  "曰く「オブジェクトとは自然変換とミーリマシン、\n"
      ++ "双方の性質を併せ持ったものである。」"
    )
    ( codeCont
      $  " ---- Natural ----\n"
      ++ "                          forall x. f x -> g  x\n\n" 
      ++ " ---- Mealy ----\n"
      ++ "newtype Mealy a b \n"
      ++ "  = Mealy  { runMealy  ::           a   ->   (b, Mealy a b) }\n\n"
      ++ " ---- Object ----\n"
      ++ "newtype Object f g \n"
      ++ "  = Object { runObject :: forall x. f x -> g (x, Object f g) }"
    )
  bigList
    [ "自然変換は関手から関手への変換"
    , "ミーリマシンは内部状態を保持する"
    , "オブジェクトは双方の性質を併せ持っている\n\n"
    , "「関手」を「メッセージ」に置き換えてみよう\n\n"
    , "・・・おやっ？"
    ]
  slideTitle .= "つまり・・・"
  taka "オブジェクトは\n内部状態を持ち\nメッセージの変換を\n行うものである"

-------------------------------------------------
-- methodAndProgress 

methodAndProgress :: Taka ()
methodAndProgress = do
  slideTitle .= "メッセージを定義する"
  vertical
    [ parCont
      $  "サンプルとしてカウンターを作ろう\n"
      ++ "まずGADTs言語拡張を用いて、メッセージを定義する。"
    , codeCont
      $  "data Counter a where\n"
      ++ "  PrintCount :: Counter ()\n"
      ++ "  Increment :: Counter ()\n"
    ] 
  big 
    $  "尚、この段階でCounter型が、\n"
    ++ "Functorのインスタンスにならない事は、\n"
    ++ "あまり問題ではない。\n\n"
    ++ "その型が圏論的に関手であったとしても、\n"
    ++ "必ずFunctorのインスタンスになるとは\n"
    ++ "限らないのだが、難しい話になるので割愛。"
  slideTitle .= "オブジェクトを作成"
  vertical
    [ parCont
      $  "実際にオブジェクトを作ってみよう。\n"
      ++ "とりあえず、簡単に再帰関数を使って実装してみる。"
    , codeCont
      $  "-- メッセージとしてCounterを受信、IOを送信\n"
      ++ "counter :: Int -> Object Counter IO\n"
      ++ "counter i = Object $ \\case \n"
      ++ "  Increment -> return ((), counter (i + 1))\n"
      ++ "  PrintCount -> print i >> return ((), counter i)"
    ] 
  slideTitle .= "インスタンス"
  vertical
    [ parCont
      $  "ミーリマシンの時のように\n"
      ++ "MVarで状態管理するための演算子を準備。\n"
      ++ "IO上で状態管理されているオブジェクトは\n"
      ++ "インスタンスと呼べるだろう。"
    , codeCont
      $  "type Instance f g = MVar (Object f g)\n\n"
      ++ "(.-) :: Instance f IO -> f a -> IO a\n"
      ++ "i .- m = modifyMVar i $ \\o -> do\n"
      ++ "   (x, no) <- runObject o $ m\n"
      ++ "   return (no, x)"
    ] 
  slideTitle .= "動作確認"
  twinBottom
    ( parCont
      $  "以下のようなコードを書く事によって、\n"
      ++ "実際に動作させる事が出来る。"
    )
    ( codeCont
      $  "sample :: IO ()\n"
      ++ "sample = do\n"
      ++ "  cntr <- newMVar $ counter 10 -- インスタンス生成\n"
      ++ "  cntr.-PrintCount         -- 出力：10\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-PrintCount         -- 出力：14"
    )  
  slideTitle .= "文字列オブジェクト"
  vertical
    [ parCont
      $  "続いて、以下のようなメソッドを持ち、\n"
      ++ "内部状態として文字列を保持するオブジェクトを、\n"
      ++ "作る事を考えてみよう。"
    , codeCont
      $  "data StringObject a where\n"
      ++ "  PrintString :: StringObject ()\n"
      ++ "  GetString :: StringObject String\n"
      ++ "  SetString :: String -> StringObject ()"
    ]  
  twinBottom
    ( parCont
      $  "状態を持ったオブジェクトを作るのは、\n"
      ++ "Stateモナドを利用できたほうが便利なので・・・"
    )
    ( codeCont
      $  "unfoldO :: forall f r g. Functor g \n"
      ++ "  => (forall a. r -> f a -> g (a, r)) -> r -> Object f g\n"
      ++ "unfoldO h = go\n"
      ++ "  where\n"
      ++ "    go :: Functor g => r -> Object f g\n"
      ++ "    go r = Object $ fmap (fmap go) . h r\n\n"
      ++ "(@~) :: Functor g \n"
      ++ "  => s -> (forall a. f a -> StateT s g a) -> Object f g\n"
      ++ "s0 @~ h = unfoldO (\\s f -> runStateT (h f) s) s0"
    )  
  vertical
    [ parCont
      $  "以下のようにして\n"
      ++ "簡単に状態を扱うオブジェクトを作成できる。"
    , codeCont
      $  "stringObject :: String -> Object StringObject IO\n"
      ++ "stringObject s = s @~ \\case\n"
      ++ "  PrintString -> get >>= liftIO . putStrLn\n"
      ++ "  GetString -> get\n"
      ++ "  SetString s -> put s"
    ]  
  vertical
    [ parCont
      $  "実際に動作させるコード例は次のとおり。"
    , codeCont
      $  "sample :: IO ()\n"
      ++ "sample = do\n"
      ++ "  str <- newMVar $ stringObject \"Hello!!\"\n"
      ++ "  str.-PrintString -- 出力：Hello!!\n"
      ++ "  str.-SetString \"Good Bye!!\"\n"
      ++ "  str.-PrintString -- 出力：Good Bye!!"
    ]
  slideTitle .= "所感"
  bigList
    [ "オブジェクトの作成はややクセがあるか"
    , "使用者の使用感は一般的なOOPLに近い感じ"
    , "参照されなくなったMVarはGCが破棄"
    , "複雑な状態に対しLensの応用も検討できそう"
    ]
  slideTitle .= "受信メッセージをモナドに"
  bigList
    [ "モナドは手続きの表現だった"
    , "受信メッセージとしてCounter型を定義した"
    , "送信メッセージのIOはモナドである\n\n"
    , "もし受信メッセージもモナドだとしたら？"
    ]
  slideTitle .= "Counter型の手続きって？"
  bigList
    [ "PrintCount/Incrementを命令に持つ言語内DSL"
    , "モナドなのでdo構文により記述できる"
    , "Haskellの制御構文がそのまま使える"
    , "モナドを操作する高度な関数が使える\n\n"
    ,     "受信メッセージがモナドなら\n"
       ++ "　メソッドを拡張できるのでは？"
    ]
  slideTitle .= "問題点"
  taka "モナドを作るのは\nけっこう大変"
  slideTitle .= "Operationalモナド"
  vertical 
    [ parCont
      $  "任意の多相型を\n"
      ++ "あっという間にモナドにしてしまう、\n"
      ++ "超便利なライブラリ。今回は詳細は割愛。"
    , codeCont
      $  "newtype Program t a = ...\n\n"
      ++ "instance Functor (Program t) where\n"
      ++ "instance Applicative (Program t) where\n"
      ++ "instance Monad (Program t) where\n"
      ++ "liftP :: t a -> Program t a"
    ]
  twinBottom
    ( parCont 
      $  "Operationalモナドの仕組みを使って、\n" 
      ++ "Counterのモナド版、CounterPモナドを定義" 
    )
    ( codeCont
      $  "type CounterP = Program Counter\n\n"
      ++ "printCount :: CounterP ()\n"
      ++ "printCount = liftP PrintCount\n\n"
      ++ "increment :: CounterP ()\n"
      ++ "increment = liftP Increment\n\n"
    )
  vertical
    [ parCont
      $  "今作成したCounterPモナドを使って、\n"
      ++ "引数で指定された回数だけIncrementする命令を定義。\n"
      ++ "これを受信メッセージ（メソッド）として使いたい。\n"
    , codeCont
      $  "incNPrint :: Int -> CounterP ()\n"
      ++ "incNPrint x = do\n"
      ++ "  forM [1 .. x] $ \\i -> do\n"
      ++ "    increment\n"
      ++ "  printCount"
    ]
  slideTitle .= "cascading関数"
  twinBottom
    ( parCont
      $  "CounterPモナドをメッセージとして受信するオブジェクトを、\n"
      ++ "新たに作るのは効率が悪い。そこで・・・\n"
    )
    ( codeCont
      $  "cascadeObject :: Monad g \n"
      ++ "  => Object f g -> Program f a -> g (a, Object f g)\n"
      ++ "cascadeObject obj m = case view m of\n"
      ++ "  Return a -> return (a, obj)\n"
      ++ "  f :>>= k -> \n"
      ++ "    runObject obj f >>= \\(a, obj') -> cascadeObject obj' (k a)\n\n"
      ++ "cascading :: (Functor g, Monad g) \n"
      ++ "  => Object f g -> Object (Program f) g\n"
      ++ "cascading = unfoldO cascadeObject "
    )
  vertical
    [ parCont
      $  "cascading関数を使えば、\n"
      ++ "既に作成したcounterオブジェクトの受信メッセージを\n"
      ++ "モナドに変更したcounterPオブジェクトを簡単に作れる。"
    , codeCont
      $  "counterP :: Int -> Object CounterP IO\n"
      ++ "counterP = cascading . counter"
    ]
  vertical
    [ parCont
      $  "こうして作られたオブジェクトは、\n"
      ++ "CounterPモナドを用いて作成したincNPrint関数を、\n"
      ++ "メソッドとして使う事ができる。"
    , codeCont
      $  "sample :: IO ()\n"
      ++ "sample = do\n"
      ++ "  cntr <- newMVar $ counterP 10\n"
      ++ "  cntr.-printCount       -- 出力：10\n"
      ++ "  cntr.-(incNPrint 100)  -- 出力：110\n"
    ]

-------------------------------------------------
-- objectExtension

objectExtension :: Taka ()
objectExtension = do
  slideTitle .= "継承の話"
  big
    $  "「親クラスを元に子クラスを派生する」\n"
    ++ "程度の認識になってしまいがちだが\n"
    ++ "実際には、いくつかの拡張機能の\n"
    ++ "寄せ集めだという事がわかる。"
  slideTitle .= "例えば"
  bigList
    [ "メソッドの追加"
    , "メソッドのオーバーライド"
    , "親クラスのメソッド呼び出し"
    ]
  slideTitle .= "２種類の合成"
  big
    $  "\n\nobjectiveでは、\n"
    ++ "２種類の方法でオブジェクトを合成し\n"
    ++ "これらの機能を実現して行く"
  vertical
    [ parCont
      $  "【縦の合成】\n"
      ++ "左辺のオブジェクトの受信メッセージを受け\n"
      ++ "右辺のオブジェクトの送信メッセージを送る\n"
      ++ "新しいオブジェクトを作成する。"
    , codeCont
      $  "(@>>@) :: Functor h => Object f g -> Object g h -> Object f h\n"
      ++ "Object m @>>@ Object n = Object $ fmap joinO . n . m\n\n"
      ++ "joinO :: Functor h => ((a, Object f g), Object g h) -> (a, Object f h)\n"
      ++ "joinO ((x, a), b) = (x, a @>>@ b)\n"
    ]
  vertical
    [ parCont
      $  "【横の合成】\n"
      ++ "左辺のオブジェクトの受信メッセージと\n"
      ++ "右辺のオブジェクトの受信メッセージを纏め上げた\n"
      ++ "新しいオブジェクトを作成する。"
    , codeCont
      $  "data Sum f g a = InL (f a) | InR (g a)\n"
      ++ "\n"
      ++ "(@||@) :: Functor m => Object f m -> Object g m -> Object (Sum f g) m\n"
      ++ "a @||@ b = Object $ \\case\n"
      ++ "  InL f -> fmap (fmap (@||@b)) $ runObject a f\n"
      ++ "  InR g -> fmap (fmap (a@||@)) $ runObject b g\n"
    ]
  slideTitle .= "具体例"
  vertical
    [ parCont
      $  "例として、Counterオブジェクトを親とし、\n"
      ++ "以下のTwiceIncメソッドを呼び出すと、\n"
      ++ "Incrementが二回呼ばれるような拡張を行う。"
    , codeCont
      $  "data TwiceInc a where\n"
      ++ "  TwiceInc :: TwiceInc ()"
    ]
  vertical
    [ parCont
      $  "まず、TwiceIncを受信し、CounterPを送信する\n"
      ++ "オブジェクトを作成する。\n"
    , codeCont
      $  "twiceInc :: Object TwiceInc CounterP\n"
      ++ "twiceInc = liftO $ \\case\n"
      ++ "  TwiceInc -> do\n"
      ++ "    increment\n"
      ++ "    increment"
    ]
  vertical
    [ parCont
      $  "cascading関数で、twiceIncオブジェクトの\n"
      ++ "受信メッセージをモナドに変換する。"
    , codeCont
      $  "type TwiceIncP = Program TwiceInc\n\n"
      ++ "twiceIncrement :: TwiceIncP ()\n"
      ++ "twiceIncrement = liftP TwiceInc\n\n"
      ++ "twiceIncP :: Object TwiceIncP CounterP\n"
      ++ "twiceIncP = cascading twiceInc\n"
    ]
  vertical
    [ parCont
      $  "echoと呼ばれる単位オブジェクトと横合成\n"
      ++ "最後に親であるcounterPと縦合成"
    , codeCont
      $  "echo :: Functor f => Object f f\n"
      ++ "echo = Object (fmap (\\x -> (x, echo))) \n\n"
      ++ "twiceCounter :: Int -> Object (Sum CounterP TwiceIncP) IO\n"
      ++ "twiceCounter x = echo @||@ twiceIncP @>>@ counterP x"
    ] 
  slideTitle .= "動作確認してみる"
  twinBottom
    ( parCont
      $  "twiceIncrementメソッドが\n"
      ++ "期待した動作をしている事を確認。"
    )
    (  codeCont
        $  "sample :: IO ()\n"
        ++ "sample = do\n"
        ++ "  tcntr <- newMVar $ twiceCounter 10\n"
        ++ "  tcntr.-InL printCount -- 出力：10\n"
        ++ "  tcntr.-InL (incNPrint 100)\n"
        ++ "  tcntr.-InR twiceIncrement\n"
        ++ "  tcntr.-InL printCount -- 出力：112\n"
    )
  bigList
    [ "やりたい事のわりに手順が煩雑？"
    , "Haskellの抽象力でどうにでもなりそう"
    , "InLとかInRとかどうにかならないのか"
    , "これって親子間に多相性無いよね？"
    , "→effの応用で解決出来るらしい\n\n"
    , "情報不足、申し訳ないm(__)m"
    ]

-------------------------------------------------
-- categoryAndOOP

categoryAndOOP :: Taka ()
categoryAndOOP = do
  return ()

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
        , "東京都近郊に生息(休職中)\n\n"
        , "クルージング(スケボー)"
        , "ボルダリング\n\n"
        , "スプラトゥーン"
        , "当たらない方のリッター使い"
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
    ++ "　永遠に開発中のオーディオインターフェイス\n"
    ++ "　PortAudioのラッパーのラッパー\n"
    ,  "ブログ：http://tune.hateblo.jp/\n"
    ++ "　ポーカーゲームを作る連載やってます"
    ]
  

