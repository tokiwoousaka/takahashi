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
    title "FuctioNaL with OOP\n～objectiveが諍いを終演に導く～" 
      $  "2016/4/16 ちゅーん(@its_out_of_tune)"
  profile
  header "OOP vs 関数型？" oopVsFunctional
  header "objectiveを使う" useObjective
  header "HaskellらしいOOP" oopThatLikeHaskell
  header "最後に" sammary

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"

-------------------------------------------------
-- oopVsFunctional

oopVsFunctional :: Taka ()
oopVsFunctional = do
  slideTitle .= "タイトルについて"
  big "インパクトがあれば何でも良いかなって\n反省はしていない"
  slideTitle .= "この節でやりたかった事"
  bigList
    [ "関数型vsOOPでググる\n\n"
    , "地獄絵図\n\n"
    , "そんな論争は無意味だ！"
    ]
  slideTitle .= "実際にググってみた"
  par "一言二事言いたい事はあるものの\n言うほど酷く無かった"
  slideTitle .= "なので"
  taka "次行くよ次"

-------------------------------------------------
-- useObjective

useObjective :: Taka ()
useObjective = do
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
    [ "クラスとインスタンス" , "メソッド呼び出し"
    , "手続き／制御構造"
    , "抽象クラスと継承"
    , "インターフェイスと実装\n\n"
    , "・・・ってあれ？"
    ]
  taka 
    $  "オブジェクト指向に\n"
    ++ "必要なものって\n"
    ++ "やったら多くね？"
  slideTitle .= "今日のお話"
  big 
    $  "\n\n我々が「欲しい」と考える\n"
    ++ "OOPLの機能を得るための\n"
    ++ "「Haskellらしい」仕組みの紹介"
  slideTitle .= "objective？"
  big
    $  "@fumievalさんによる\n"
    ++ "Haskell上でOOPを実現するための道具立て\n\n"
    ++ "https://hackage.haskell.org/package/objective\n\n"
    ++ "CabalなりStackなりで\n"
    ++ "良い感じにインストールして使おう"
  slideTitle .= "実際に使ってみる"
  vertical
    [ parCont
      $  "サンプルとしてカウンターを作ろう\n"
      ++ "まずGADTs言語拡張を用いてインターフェイスを定義。"
    , codeCont
      $  "data Counter a where\n"
      ++ "  PrintCount :: Counter ()\n"
      ++ "  Increment :: Counter ()"
    ] 
  vertical
    [ parCont
      $  "インターフェイスを実装する\n"
      ++ "(@~)演算子の左辺に状態の初期値を与える。\n"
      ++ "右辺は StateT s IO モナドで各メソッドを実装。"
    , codeCont
      $  "counter :: Int -> Object Counter IO\n"
      ++ "counter i = i @~ \\case\n"
      ++ "  PrintCount -> get >>= liftIO . print\n"
      ++ "  Increment -> modify (+1)"
    ] 
  twinBottom
    ( parCont
      $  "new関数でインスタンス作成\n"
      ++ "(.-)演算子でメソッド呼び出し"
    )
    ( codeCont
      $  "main :: IO ()\n"
      ++ "main = do\n"
      ++ "  cntr <- new $ counter 10\n"
      ++ "  cntr.-PrintCount -- 10が出力される\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-Increment\n"
      ++ "  cntr.-PrintCount -- 14が出力される"
    )
  taka "ね？簡単でしょう？"
  slideTitle .= "オブジェクトの拡張" 
  big 
    $  "objectiveにももちろん\n"
    ++ "既存のオブジェクトを拡張するための\n"
    ++ "便利な機能が備わっています。"
  vertical
    [ parCont
      $  "その前にobjectiveの型の読み方を説明しておこう\n"
      ++ "便宜上「インターフェイス」「メソッド」を使ったが\n"
      ++ "objectiveの基礎的な考え方はメッセージパッシングだ"
    , codeCont
      $  "-- 次のように送受信メッセージを型引数として取る\n"
      ++ "Object [受信メッセージ] [送信メッセージ]\n\n"
      ++ "-- インスタンスを使うにはIOを送信しなくてはいけない\n"
      ++ "new :: Object f IO -> m (Instance f IO)\n"
      ++ "(.-) :: Instance f IO -> f a -> IO a"
    ] 
  twinTop
    ( parCont
      $  "【縦の合成】\n"
      ++ "左辺のオブジェクトの受信メッセージを受け\n"
      ++ "右辺のオブジェクトの送信メッセージを送る\n"
      ++ "新しいオブジェクトを作成する。"
    )
    ( codeCont "(@>>@) :: Functor h => Object f g -> Object g h -> Object f h" )
  twinTop
    ( parCont
      $  "【横の合成】\n"
      ++ "左辺のオブジェクトの受信メッセージと\n"
      ++ "右辺のオブジェクトの受信メッセージを纏め上げた\n"
      ++ "新しいオブジェクトを作成する。"
    )
    ( codeCont
      $  "data Sum f g a = InL (f a) | InR (g a)\n"
      ++ "(@||@) :: Functor m => Object f m -> Object g m -> Object (Sum f g) m"
    )
  slideTitle .= "合成による拡張は軽量"
  vertical
    [ parCont
      $  "二つの合成については、\n"
      ++ "次のように解釈すると分かりやすい"
    , listCont
      [ "オーバーライド：縦合成"
      , "メソッドの追加：横合成"
      ]
    , parCont
      $  "上手く組み合わせれば、\n"
      ++ "継承と概ね同等の拡張を実現出来る"
    ]
  par "実際使いこなすにはOperationalとか\nもう少し高度な知見も必要ですが……"
  slideTitle .= "objectiveの継承について"
  bigList
    [ "やりたい事のわりに煩雑になりそう？"
    , "InLとかInRとかどうにかならないのか"
    , "これって親子間に多相性無いよね？"
    , "→Haskellの抽象力で色々できそう"
    , "→型クラスを上手く使おう"
    , "→Effの応用でも解決出来るらしい"
    ] 
  taka "っていうか\nそもそも"
  list
    [ "継承ってやたら沢山機能があるよね。\n\n"
    , "オーバーライド／メソッド追加／親要素へのアクセス……\n\n"
    , "これ全部が必要な拡張って既に設計に難がありそう\n\n"
    , "全部ひとからげに１機能で提供してるOOPLって……"
    ]
  slideTitle .= "結局の所"
  taka "必要な拡張を必要なだけ\n明示的に出来れば良い"

-------------------------------------------------
-- oopThatLikeHaskell

oopThatLikeHaskell :: Taka ()
oopThatLikeHaskell = do
  slideTitle .= "モナドという例"
  taka "突然ですが、\n手続きプログラミングを\n説明できますか？"
  taka "そもそも"
  taka "「手続き」って\n何なんすか(´・ω・｀)"
  slideTitle .= "手続きの要件とモナド"
  list 
    [ "何か作用のある「命令」を並べたい -> (>>=)"
    , "命令は引数を取ったり結果を返すかも -> 無視／Unit"
    , "「何もしない」命令が存在する -> return"
    , "「何もしない」命令は消しても影響が無い -> 単位元即"
    , "命令は良い感じに関数／メソッド化出来る -> 結合則"
    ]
  slideTitle .= "形式的であるという事"
  par 
    $  "\n\n「数学」という言葉を使うとまた荒れそうなので\n"
    ++ "「形式的」という言葉に言い換えます\n\n"
    ++ "ここでいう「形式的」は\n"
    ++ "「厳密な定義の組み合わせで曖昧性／矛盾なく説明できる」\n"
    ++ "くらいの意味です"
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
  slideTitle .= "オブジェクトは何か言い切る"
  taka
    $  "①メッセージを送受信出来て\n"
    ++ "②状態を持っているもの"
  vertical
    [ parCont 
      $  "①メッセージの送受信\n"
      ++ "メッセージを関手として、自然変換が相当する"
    , codeCont 
      $  "nat :: m a -> n a\n\n"
      ++ "--自然変換は自然性という性質を満たす\n"
      ++ "nat . fmap f == fmap f . nat" 
    ]
  vertical
    [ parCont
      $  "②状態を持つ\n"
      ++ "ミーリ・マシン：入力aを受けると出力bを返し、\n"
      ++ "自身の状態を書き換えるオートマトンの一種。"
    , codeCont 
      $  "newtype Mealy a b = Mealy\n"
      ++ "  { runMealy :: a -> (b, Mealy a b) }\n"
    ]
  taka "合体！！"
  twinBottom
    ( parCont 
      $  "オブジェクトはミーリ・マシンの性質を持った\n"
      ++ "ただの自然変換だよ？何か問題でも？"
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
  slideTitle .= "Haskellらしさとは"
  big
    $  "対象について形式的に述べる事によって\n"
    ++ "それが何なのか明瞭になるばかりでは無く\n"
    ++ "その対象の持つ性質を遺憾なく発揮した\n"
    ++ "高度なプログラミングを実現出来る！"
  slideTitle .= "Objectは圏の射"
  par
    $  "おまけ：\n"
    ++ "縦合成は単位元としてechoという\n"
    ++ "特殊なオブジェクトを持ち、結合則を満たします。\n\n"
    ++ "つまり、メッセージを対象としてオブジェクトを射とした、\n"
    ++ "「オブジェクトの圏」を定義できます。\n\n"
    ++ "嬉しい✌('ω'✌ )三✌('ω')✌三( ✌'ω')✌"

-------------------------------------------------
-- sammary 

sammary :: Taka ()
sammary = do
  slideTitle .= "objectiveの使い所"
  par
    $  "開発者@fumievalさん曰く\n"
    ++ "オブジェクトは現実的な問題を解決するには\n"
    ++ "強すぎる道具立てである、従って……\n\n"
    ++ "「ゲームとかGUIくらいしか無いと思います」"
  taka "元も子もねぇ\n(ノ｀Д´)ノ彡┻━┻"
  slideTitle .= "ちゅーんさんの考え"
  big 
    $  "もっと軽いシチュエーションでも\n"
    ++ "使い所あるんじゃ無いかなぁ……例えば……"
  taka
    $  "やや複雑な状態を\n"
    ++ "脳死状態で管理したい時"
  par "ちょっとしたツール作る時とかに。\n\n適切に使わないと死ぬかもしれない"
  slideTitle .= "まとめ"
  bigList
    [ "objectiveを使ってHaskellでOOP出来るよ"
    , "拡張機能はよくあるOOPLより軽量だよ"
    , "複雑な拡張は大変だけどだいたい十分だよ"
    , "objectiveは形式的なのが強みだよ"
    , "ゲームとかGUIとか、他にも使い所あるかもね\n\n"
    , "高度な応用の話は論文を呼んでね！"
    ]

-------------------------------------------------
-- profile 
profile :: Taka ()
profile = do
  slideTitle .= "自己紹介"
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont [ "野生のHaskller(28♂)\n\n"
        , "クルージング(スケボー)"
        , "ボルダリング"
        , "ポーカー(テキスサス・ホールデム)\n\n"
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
  slideTitle .= "近状報告"
  img HStretch "../img/NLNagoya/sc1.png"
  twinLeft
    ( takaCont "尾てい骨\n骨折" )
    ( imgCont HStretch "../img/NLNagoya/kossetu.jpg" )
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 40
    par "あと東京から引っ越して来て某社に入社しました"
