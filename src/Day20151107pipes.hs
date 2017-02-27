module Day20151107pipes 
  ( day20151107pipes
  ) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20151107pipes :: IO ()
day20151107pipes = do
  let fileName = "contents/day20151107pipes.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions

  stateSandbox $ do  
    title "Pipesチュートリアルを\n読んだ話"
      $  "2015/11/7 関数型ストリーム処理勉強会\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  profile

  header "近状" recentSituation
  header "Pipesとは" concept
  header "Pipesの型" typesInPipes
  header "Proxyをひも解く" aboutProxy
  header "こまごまとした話" insignificant
  header "まとめ" summary

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"

-------------------------------------------------
-- recentSituation

recentSituation :: Taka ()
recentSituation = do
  slideTitle .= "宣伝"
  taka "来る11/23"
  taka "東京流通センター\n第二展示場"
  taka "第二十一回\n文学フリマ東京"
  taka "暗黒定数式 Vol2\n寄稿してます"
  taka "❤(ӦｖӦ｡)よろしく"
  slideTitle .= "ここ数日間の活動"
  bigList
    [ "~10/28：暗黒定数式の原稿"
    , "~11/2：原稿見直しとか"
    , "~11/3：イカ"
    , "~11/4：イカ"
    , "~11/5：Pipesを初めてインストール"
    , "~11/6：資料作った"
    ]
  slideTitle .= "実は・・・"
  taka "ストリーム処理\nライブラリとか\n今まで使った事無い"
  slideTitle .= "そんなわけで"
  taka "今日はゆるふわに行きます"

-------------------------------------------------
-- concept

concept :: Taka ()
concept = do
  slideTitle .= "Pipes３つの特徴"
  bigList
    [ "Effects"
    , "Streaming"
    , "Composability"
    ]
  slideTitle .= "(´・ω・｀)？"
  taka "よーわからん"
  slideTitle .= "超簡単なサンプル"
  code "echo(三回)"
    $  "import Pipes\n"
    ++ "import qualified Pipes.Prelude as P\n\n"
    ++ "main :: IO ()\n"
    ++ "main = do\n"
    ++ "  runEffect $ P.stdinLn >-> P.take 3 >-> P.stdoutLn"
  slideTitle .= "(>->)演算子？"
  big "Haskellなんだから\n型を見れば良いんちゃう？"
  vertical [ parCont "GHCiで確認"
    , codeCont
      $  "ghci> :t (>->)\n"
      ++ "(>->)\n"
      ++ "  :: Monad m => Proxy a' a () b m r ->\n"
      ++ "     Proxy () b c' c m r -> Proxy a' a c' c m r"
    , parCont "なるほどわからん"
    ]

-------------------------------------------------
-- typesInPipes

typesInPipes :: Taka ()
typesInPipes = do
  slideTitle .= "Pipesの４つの型"
  code 
    (  "基本的には全部、Proxyを元にtype宣言\n"
    ++ "Proxyの詳細は後述"
    )
    (  "type Effect        m r = Proxy X  () () X m r\n"
    ++ "type Producer   b  m r = Proxy X  () () b m r\n"
    ++ "type Consumer a    m r = Proxy () a  () X m r\n"
    ++ "type Pipe     a b  m r = Proxy () a  () b m r"
    )
  slideTitle .= "(>->)の型を読み替え"
  code 
    (  "Producer >-> Pipes >-> Consumer のように繋ぐ\n"
    ++ "各型引数の役割について推測してみよう"
    )
    (  "infixl 7 >->\n"
    ++ "(>->) :: Producer b m r -> Consumer b   m r -> Effect       m r\n"
    ++ "(>->) :: Producer b m r -> Pipe     b c m r -> Producer   c m r\n"
    ++ "(>->) :: Pipe   a b m r -> Consumer b   m r -> Consumer a   m r\n"
    ++ "(>->) :: pipe   a b m r -> pipe     b c m r -> Pipe     a c m r\n\n"
    ++ "-- ※画面に収まらない都合上Monad制約は省略してます"
    )
  slideTitle .= "runEffect関数"
  vertical
    [ parCont
      $  "ProducerからConsumerまで繋げば、Effect型になるので\n"
      ++ "runEffect関数でアクションを実行する事ができる。"
    , codeCont
      $  "ghci> :t runEffect\n"
      ++ "runEffect :: Monad m => Effect m r -> m r"
    , parCont
      $  "別にIOアクションじゃなくても良い" 
    ]
  slideTitle .= "Pipes.Preludeの３関数"
  code "最初のサンプルに出てきた奴(実際にはちょっと違うケド)"
    $  "P.stdinLn  :: MonadIO m => Producer String m ()\n"
    ++ "P.stdoutLn :: MonadIO m => Consumer String m ()\n"
    ++ "P.take     :: Monad m   => Int -> Pipe a a m ()"
  slideTitle .= "超簡単なサンプル再掲"
  code "EffectになっているのでrunEffect出来る"
    $  "main :: IO ()\n"
    ++ "main = do\n"
    ++ "  runEffect $ P.stdinLn >-> P.take 3 >-> P.stdoutLn\n"
    ++ "                  ^            ^              ^\n"
    ++ "                  |            |              |\n"
    ++ "              Producer        Pipe        Consumer\n"

-------------------------------------------------
-- aboutProxy

aboutProxy :: Taka ()
aboutProxy = do
  slideTitle .= "Proxyの構造"
  code "Tutorialの次の図がわかりやすい"
    (  " Proxy a' a b' b m r\n"
    ++ "\n"
    ++ " Upstream | Downstream\n"
    ++ "     +---------+\n"
    ++ " a' <==       <== b'  -- Information flowing upstream\n"
    ++ "     |         |\n"
    ++ " a  ==>       ==> b   -- Information flowing downstream\n"
    ++ "     +----|----+\n"
    ++ "          v\n"
    ++ "          r"
    )
  slideTitle .= "Producerの構造"
  code 
    (  "upstream側が閉じている。\n"
    ++ "尚、X = Void"
    )
    (  "type Producer b = Proxy X () () b\n\n"
    ++ " Upstream | Downstream\n"
    ++ "     +---------+\n"
    ++ " X  <==       <== ()  -- 無視\n"
    ++ "     |         |\n"
    ++ " () ==>       ==> b\n"
    ++ "     +----|----+\n"
    ++ "          v\n"
    ++ "          r\n"
    )
  slideTitle .= "Effectの構造"
  code "downstream側が閉じている。"
    (  "type Consumer a = Proxy () a () X\n\n"
    ++ "Upstream | Downstream\n"
    ++ "    +---------+\n"
    ++ "() <==       <== ()  -- 無視\n"
    ++ "    |         |\n"
    ++ "a  ==>       ==> X\n"
    ++ "    +----|----+\n"
    ++ "         v\n"
    ++ "         r\n"
    )
  slideTitle .= "Pipeの構造"
  code "up/downstream双方向とも開いている"
    (  "type Pipe a b = Proxy () a () b\n\n"
    ++ "Upstream | Downstream\n"
    ++ "    +---------+\n"
    ++ "() <==       <== ()  -- 無視\n"
    ++ "    |         |\n"
    ++ "a  ==>       ==> b\n"
    ++ "    +----|----+\n"
    ++ "         v\n"
    ++ "         r\n"
    )
  slideTitle .= "Effectの構造"
  code "ProducerからConsumerへの流れが完成している。"
    (  "type Effect = Proxy X () () X\n\n"
    ++ " Upstream | Downstream\n"
    ++ "    +---------+\n"
    ++ "X  <==       <== () -- やっぱ無視\n"
    ++ "    |         |\n"
    ++ "() ==>       ==> X\n"
    ++ "    +----|----+\n"
    ++ "         v\n"
    ++ "         r\n"
    )
  slideTitle .= "がっちゃんこ"
  code "(>->)演算子で繋ぐとこんな感じ"
    (  "       Producer                Pipe                 Consumer\n"
    ++ "    +-----------+          +----------+          +------------+\n"
    ++ "    |           |          |          |          |            |\n"
    ++ "X  <==         <==   ()   <==        <==   ()   <==          <== ()\n"
    ++ "    |  stdinLn  |          |  take 3  |          |  stdoutLn  |\n"
    ++ "() ==>         ==> String ==>        ==> String ==>          ==> X\n"
    ++ "    |     |     |          |    |     |          |      |     |\n"
    ++ "    +-----|-----+          +----|-----+          +------|-----+\n"
    ++ "          v                     v                       v\n"
    ++ "          ()                    ()                      ()"
    )
  code "結果、こうなる"
    (  "                   Effect\n"
    ++ "    +-----------------------------------+\n"
    ++ "    |                                   |\n"
    ++ "X  <==                                 <== () -- 無視じゃ\n"
    ++ "    |  stdinLn >-> take 3 >-> stdoutLn  |\n"
    ++ "() ==>                                 ==> X\n"
    ++ "    |                                   |\n"
    ++ "    +----------------|------------------+\n"
    ++ "                     v\n"
    ++ "                     ()\n"
    )
  slideTitle .= "内部実装的な話"
  code 
    (  "モノとしては単なるモナドっぽい。\n"
    ++ "中身の掘り下げは時間が足りなくて出来なかった。"
    )
    (  "data Proxy a' a b' b m r\n"
    ++ "    = Request a' (a  -> Proxy a' a b' b m r )\n"
    ++ "    | Respond b  (b' -> Proxy a' a b' b m r )\n"
    ++ "    | M          (m    (Proxy a' a b' b m r))\n"
    ++ "    | Pure    r\n\n"
    ++ "instance Monad m => Monad (Proxy a' a b' b m) where"
    )

-------------------------------------------------
-- insignificant

insignificant :: Taka ()
insignificant = do
  slideTitle .= "(>~)演算子"
  code 
    (  "わりと基本っぽい。Proxyの返却値 r を、\n"
    ++ "次の処理に繋ぐ演算子なのだが、十分にいじれなかった。"
    )
    (  "(>~) :: Effect       m b -> Consumer b   m c -> Effect       m c\n"
    ++ "(>~) :: Consumer a   m b -> Consumer b   m c -> Consumer a   m c\n"
    ++ "(>~) :: Producer   y m b -> Pipe     b y m c -> Producer   y m c\n"
    ++ "(>~) :: Pipe     a y m b -> Pipe     b y m c -> Pipe     a y m c"
    )
  code "こんな感じの図になるらしい。"
    (  "   +-------+               +-------+           +----------+\n"
    ++ "   |       |               |       |           |          |\n"
    ++ "a ==>  f  ==> y   .->   b ==>  g  ==> y  =  a ==> f >~ g ==> y\n"
    ++ "   |   |   |    /          |   |   |           |    |     |\n"
    ++ "   +---|---+   /           +---|---+           +----|-----+\n"
    ++ "       v      /                v                    v\n"
    ++ "       b  ---'                 c                    c"
    )
  slideTitle .= "こんな型あるよ１"
  code 
    (  "upstreamからupstream、あるいは\n"
    ++ "downstreamからdownstreamの流れ。用途は良くわかっていない"
    )
    (  " type Server        b' b = Proxy X  () b' b\n"
    ++ " type Client   a' a      = Proxy a' a  () X"
    )
  slideTitle .= "こんな型あるよ２"
  code "各型の多相版、やっぱり用途は良くわからない。"
    (  "type Effect'            m r = ∀x' x y' y . Proxy x' x y' y m r\n"
    ++ "type Producer'        b m r = ∀x' x      . Proxy x' x () b m r\n"
    ++ "type Consumer'   a      m r = ∀     y' y . Proxy () a y' y m r\n\n"
    ++ "type Server'       b' b m r = ∀x' x      . Proxy x' x b' b m r\n"
    ++ "type Client'  a' a      m r = ∀     y' y . Proxy a' a y' y m r\n"
    )
  slideTitle .= "yield関数とawait関数"
  code
    (  "ProducerやConsumerを作るのに使う基礎的な関数\n"
    ++ "Tutorialはまず、この説明から入ってるけど、どうなんだ。"
    )
    (  "yield :: Monad m => a -> Producer a m ()\n"
    ++ "await :: Monad m => Consumer a m a\n"
    )
  slideTitle .= "あとはまぁ"
  taka "Hackage見ようか"

-------------------------------------------------
-- summary

summary :: Taka ()
summary = do
  slideTitle .= "まとめ"
  bigList
    [ "結局ストリーム処理良くわからない"
    , "でもPipesの使い方はそんな難しく無さそう"
    , "みた感じ綺麗な構造がチラホラ"
    , "使えるようになったら便利っぽい気はする"
    , "もうちょっと頑張る"
    ]

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
  

