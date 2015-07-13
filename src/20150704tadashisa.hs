module Main where import Control.Monad.Takahashi
import Control.Lens
import Control.Monad.State
import Control.Applicative

main :: IO ()
main = do
  writeSlide "../contents/20150704tadashisa.html" presentation
  putStrLn "Sucess."

presentation :: Taka ()
presentation = do
  setOptions

  stateSandbox $ do  
    title "正しさの話"
      $  "2015/7/4 関数型道場\n"
      ++ "by ちゅーん(@its_out_of_tune)"
  profile

  header "正しさとは何か" whatIsAccuracy
  header "(1)\n文章と型設計" aboutDocumantation
  header "(2)\nプログラムの証明" aboutProof
  header "(3)\nパラダイムと圏論" aboutParadigm
  header "まとめ" summary

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"

-------------------------------------------------
-- profile

profile :: Taka ()
profile = do
  slideTitle .= "自己紹介"
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont
        [ "野生のHaskller(27♂)"
        , "東京都近郊に生息(休職中)\n\n"
        , "クルージング(スケボー)"
        , "ボルダリング\n\n"
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
    ++ "　本スライドもこれで作成\n"
    ++ "　GHC7.10非対応 。゜。゜（ノД｀）゜。゜。"
    ,  "Sarasvati：\n"
    ++ "　永遠に開発中のオーディオインターフェイス\n"
    ++ "　PortAudioのラッパーのラッパー"
    ]

-------------------------------------------------
-- 起
whatIsAccuracy :: Taka ()
whatIsAccuracy = do
  -- 起 : プログラムにバグはつきもの
  slideTitle .= "導入"
  taka "バグの無いソフトウェアは\n作れない"
  taka "あるいは"
  taka "バグの無いソフトウェアは\n存在しない"
  vertical
    [ listCont
      [ "これ、最初に言ったの誰なんだろう"
      , "ググっても良くわからんかった"
      , "まぁ、間違いなく言える事は…"
      ]
    , takaCont2 "プログラマにとって\nバグは身近な存在である"
    ]
  taka "で"
  -- 承 : 「伝える」という観点からバグを見る
  slideTitle .= "そもそもバグって何だ"
  list
    [ "金額があわない！"
    , "メッセージがおかしい！"
    , "ミュウを捕まえた！"
    , "無限ループに陥った！"
    , "スタックが溢れた！"
    , "ぬるぽした！"
    , "彼女が出来ない！"
    ]
  slideTitle .= "バグには２種類ある"
  par
    $  "※このスライド内でのみ使用する用語です\n\n"
    ++ "【エラー】\n"
    ++ "例外、無限ループ等、\n"
    ++ "プログラムが何も結果を返せない。\n"
    ++ "【誤動作】\n"
    ++ "処理系としては正しく動作しているが、\n"
    ++ "プログラマの認識と異なった結果を返す。"
  list
     [ "金額があわない！【誤動作】"
     , "メッセージがおかしい！【誤動作】"
     , "ミュウを捕まえた！【誤動作】"
     , "無限ループに陥った！【エラー】"
     , "スタックが溢れた！【エラー】"
     , "ぬるぽした！【エラー】"
     , "彼女が出来ない！【仕様】"
     ]
  slideTitle .= "バグを防ぐためのあれこれ"
  list
    [    "純粋関数型言語"
    ,    "静的型付け言語"
    ,    "関数による明示的な型変換"
    ,    "例外処理"
    ,    "ジェネリクス(多相型)"
      ++ "　-> Maybe(Option), Either等"
    ,    "等々..."
    ]
  slideTitle .= "これだけでは回避困難なバグ"
  list
    [    "スタック溢れ等ハードウェアが絡む問題\n"
      ++ "　-> 純粋な計算の中でも立ちふさがる難問\n"
      ++ "　-> 専門外(´・ω・｀)誰かお願いします"
    ,    "無限ループ\n"
      ++ "　-> 理論的に難あり＞停止性問題\n"
      ++ "　-> 後でもう一度ちょびっとだけ触れます"
    ,    "誤動作全般\n"
      ++ "　-> プログラマ永遠のテーマ\n"
      ++ "　-> そして本日のメインターゲット"
    ]
  slideTitle .= "まずはじめに"
  taka "言葉の確認から"
  slideTitle .= "仕様と手法"
  par
    $  "【仕様】\n"
    ++ "作ろうとしているモノは何なのか、\n"
    ++ "どのように動作すべきなのか。\n\n"
    ++ "【手法】\n"
    ++ "どのような手段で仕様を記述するのか、\n"
    ++ "手続きプログラミング／オブジェクト指向…\n\n"
    ++ "尚、【手法】は時に【仕様】となる"
  slideTitle .= "人と処理系"
  par
    $  "【人と人】\n"
    ++ "チーム開発やOSS、ライブラリ等では、\n"
    ++ "仕様や手法を人と人の間で伝え合う必要がある。\n\n"
    ++ "【人と処理系】\n"
    ++ "人は仕様を、任意の手法を使って、\n"
    ++ "任意のプログラミング言語で記述する。"
  slideTitle .= "仕様／手法と人／処理系"
  twinBottom
    ( parCont2 "４つのプロセス" )
    ( listCont
      [      "人から人へ、正しく伝える\n"
          ++ "　-> 仕様を正しく伝える\n"
          ++ "　-> 手法を正しく伝える"
      ,      "人から処理系へ、正しく記述する\n"
          ++ "　-> 仕様を正しく記述する\n"
          ++ "　-> 手法を正しく記述する … うん？"
      ]
    )
  big 
    $  "正しく記述する事\n"
    ++ "　-> 処理系に正しく伝える事"
  slideTitle .= "「正しく伝える」事が重要"
  vertical
    [ listCont
      [ "仕様を正しく人に伝える"
      , "手法を正しく人に伝える"
      , "仕様を正しく処理系に伝える"
      , "手法を正しく処理系に伝える … ？？？"
      ]
    , parCont2 
      $  "これらのプロセスが「正確」に行われれば、\n"
      ++ "「誤動作」は避けられるはず？？"
    ]
  slideTitle .= "「二ヶ国語」の問題"
  vertical
    [ listCont
      [ "仕様を正しく人に伝える -> 自然言語／図"
      , "手法を正しく人に伝える -> 自然言語／図"
      , "仕様を正しく処理系に伝える -> プログラミング言語"
      , "手法を正しく処理系に伝える -> ？？？"
      ]
    , listCont2
      [ "検証は人の手でしか実施できない"
      , "自然言語そのものが曖昧性を持つ"
      , "プログラミング言語への翻訳が必要"
      ]
    ]
  vertical
    [ listCont
      [ "人から人への「伝達」の失敗 -> 誤動作"
      , "仕様に対する「検証」の失敗 -> 誤動作"
      , "プログラミング言語への「翻訳」の失敗 -> 誤動作"
      ]
    , listCont2
      [ "「人」の行いは信用ならない\n"
      , "自然言語も厳密さが足りない\n"
      , "プログラミング言語は具象的過ぎる"
      ]
    ] 
  big 
    $  "「人と処理系」を繋ぎ\n"
    ++ "「人と人」との距離を縮める\n\n"
    ++ "厳密／高度な\n"
    ++ "共通の「ことば」が欲しい。"
  -- 転 : 伝えるための関数型の３つの技術
  slideTitle .= "「正しさ」をもたらす三大技術"
  list
    [    "型設計\n"
      ++ "　-> 仕様を人と処理系に誤解なく伝える"
    ,    "証明\n"
      ++ "　-> 仕様を人と処理系に完璧に伝える"
    ,    "圏論\n"
      ++ "　-> 手法を人と処理系に誤解なく伝える"
    ]
  -- 結 : 踏まえた上での本スライドの流れ
  slideTitle .= "今日話すこと"
  bigList
    [ "(1)文章と型設計"
    , "(2)未来の開発と証明"
    , "(3)パラダイムと圏論"
    ]

-- 承
aboutDocumantation :: Taka ()
aboutDocumantation = do
  -- 起 : ハンガリアン記法は悪なのか
  slideTitle .= "ハンガリアン記法"
  vertical
    [ parCont
      $ "変数名の頭に型を表すプリフィックス"
    , codeCont
      $  "int iValue = 0;\n"
      ++ "bool bFlag = true;"
    , parCont
      $  "批判多し.Netでは禁止 : \n"
      ++ "　msdn.microsoft.com/ja-jp/library/ms229045.aspx\n"
    ]
  vertical
    [ parCont
      $  "前述のハンガリアン記法 : システムハンガリアン\n"
      ++ "対して、本来提唱されたハンガリアン記法"
    , codeCont
      $  "int xwMaxLen = 100; //xw-ウィンドウに対する相対水平座標\n"
      ++ "int cbBufferSize = 0; //cb-バイト数を表す"
    , parCont
      $  "変数の「意味」を表すプリフィックスを付ける\n"
      ++ "アプリケーションハンガリアン記法"
    ]
  vertical
    [ parCont
      $  "プリフィックスを知っていれば、\n"
      ++ "論理的な誤りを変数名から認知できる。"
    , codeCont
      $  "int xwLen = ywLen * cbBufferSize\n"
      ++ "  //バイト数×垂直座標 -> 水平座標？？？"
    , parCont
      $  "間違ったコードは間違って見えるようにする：\n"
      ++ "　http://goo.gl/lLjLu9"
    ]
  -- 承 : アプリケーションハンガリアンから型システムへ
  slideTitle .= "型による静的解析"
  twinBottom
    ( parCont
      $  "ウィンドウに対する\n"
      ++ "水平座標／垂直座標の、クラスを定義する。"
    )
    ( codeCont
      $  "  public class XPointInWindow {\n"
      ++ "    public int Value { get; set; };\n"
      ++ "    public XPointInWindow(int def) { Value = def; }\n"
      ++ "  }\n\n"
      ++ "  public class YPointInWindow {\n"
      ++ "    public int Value { get; set; };\n"
      ++ "    public YPointInWindow(int def) { Value = def; }\n"
      ++ "  }"
    )
  twinBottom
    ( parCont
      $  "ハンガリアン記法の代わりに型システムを使う。\n"
      ++ "コンパイル時に静的解析できるが、やや冗長か。"
    )
    ( codeCont
      $  "YPointInWindow yLen = new YPointInWindow(100);\n"
      ++ "ByteLen bufferSize = 100;\n\n"
      ++ "//意味する所は前のC#コードと同じだがコンパイルエラー\n"
      ++ "XPointInWindow xLen = bufferSize + yLen;\n"
    )
  twinBottom
    ( parCont
      $  "Haskellは型を作るコストが小さいため、\n"
      ++ "型による静的解析が導入しやすい。\n"
    )
    ( codeCont
      $  "newtype YPointInWindow = YPointInWindow Int \n"
      ++ "newtype XPointInWindow = XPointInWindow Int \n"
      ++ "newtype ByteLen = ByteLen Int \n\n"
      ++ "program = do\n"
      ++ "  let yLen = YPointInWindow 100\n"
      ++ "  let bufferSize = ByteLen 100 \n"
      ++ "  let xLen = yLen + bufferSize :: XPointInWindow\n"
      ++ "  ..."
    )
  big
    $  "しかも newtype なら\n"
    ++ "変換コストゼロ！\n\n"
    ++ "(ノーコストで出来るのは\n"
    ++ "Haskellの特権！)"
  twinBottom
    ( parCont 
      $  "型で値の範囲を限定する"
    )
    ( codeCont
      $  "自ブログから例を使って説明"
    )
  -- 転 : フローチャート -> UML -> 型
  slideTitle .= "仕様を伝える文章いろいろ"
  bigList
    [ "自然言語"
    , "擬似プログラミング言語"
    , "フローチャート"
    , "UML"
    , "型 <- new!!!"
    ]
  slideTitle .= "文章とパラダイム"
  bigList
    [ "自然言語【手続き／OOP／関数型】"
    , "擬似プログラミング言語【手続き】"
    , "フローチャート【手続き】"
    , "UML【OOP】"
    , "型【関数型】"
    ]
  slideTitle .= "型はドキュメント"
  taka "型が仕様を伝える？"
  twinBottom
    ( parCont
      $  "適切に型定義を行えば、\n"
      ++ "型は関数について流暢に語りだす。"
    )
    ( codeCont
      $  "newtype Height = Height Int --高さ\n"
      ++ "newtype Width = Width Int --幅\n"
      ++ "newtype Extent = Extent Int --面積\n\n"
      ++ "calcExtent :: Int -> Int -> Int\n"
      ++ "calcExtent :: Height -> Width -> Extent --明快！\n"
    )
  twinBottom
    ( parCont
      $  "複雑な問題にスケールする事ができ\n"
      ++ "TupleやMaybe等の多相型により高度な表現が可能。"
    )
    ( codeCont
      $  "----- 【ポーカーの例】 -----\n"
      ++ "-- Deck : 山札\n"
      ++ "-- DiscardList : 捨て札\n"
      ++ "-- Hand : 手札\n\n"
      ++ "drawHand \n"
      ++ "  :: Deck -> DiscardList -> Hand -> Maybe (Hand, Deck)\n"
    )
  slideTitle .= "Haddock"
  twinBottom
    ( parCont
      $  "Haskell版javadock的な"
    )
    ( codeCont "何処かからサンプルを拾って説明" )
  -- 結 : 型は静的に解析可能なドキュメント
  slideTitle .= "「型」"
  bigList
    [ "ドキュメントと呼べるだけの表現力"
    , "高階関数／多相型等でより高度な表現"
    , "コンパイル時型精査で誤りを許さない"
    , "純粋な関数なら副作用の心配なし"
    ]
  slideTitle .= "あるHaskeller曰く"
  big
   $  "適切に型設計を行った上で、\n"
   ++ "コンパイルを通す事が出来れば、\n"
   ++ "プログラムは「概ね」正しく動く"

aboutProof :: Taka ()
aboutProof = do
  -- 起 : 現状はテストに頼っている
  slideTitle .= "単なる型設計の限界"
  bigList
    [ "型で出来るのは型レベルの保証のみ"
    , "テストは依然として有効な手段"
    , "HaskellではHUnitやQuickCheckなど"
    , "テストに勝る方法は無いのか？"
    ]
  slideTitle .= "テストの限界"
  twinBottom
    ( parCont
      $  "以下の自然数型について、\n"
      ++ "plus関数が交換則を満たしている事を示せ"
    )
    ( codeCont 
      $  "data Nat = O | S Nat deriving (Show, Eq)\n\n"
      ++ "plus :: Nat -> Nat -> Nat\n"
      ++ "plus O n = n\n"
      ++ "plus (S n') n = plus O (S $ plus n' n)\n"
    )
  slideTitle .= "HUnit"
  twinBottom
    ( parCont
      $  "Haskell版JUnitであるHUnitを使う、\n"
      ++ "具体例の単位でしかテスト出来ない。"
    )
    ( codeCont 
      $  "tests = TestList\n"
      ++ "  [ \"commutative1\" ~: plus (S (S O)) (S O) \n"
      ++ "                  ~=? plus (S O) (S (S O))\n"
      ++ "  , \"commutative2\" ~: plus (S (S (S O))) (S (S O)) \n"
      ++ "                  ~=? plus (S (S O)) (S (S (S O)))\n"
      ++ "  ]\n\n"
      ++ "main = runTestTT tests >>= print\n"
    )
  slideTitle .= "QuickCheck"
  twinBottom
    ( parCont
      $  "QuickCheckでは、\n"
      ++ "テストしたい「性質」を記述する。"
    )
    ( codeCont  
      $  "instance Arbitrary Nat where\n"
      ++ "  arbitrary = elements (take 10000 $ es O)\n"
      ++ "    where es x = x : es (S x)\n\n"
      ++ "propComm :: (Nat, Nat) -> Bool\n"
      ++ "propComm (x, y) = plus x y == plus y x\n\n"
      ++ "main = quickCheck propComm\n"
    )
  big 
    $  "「何を」テストしたいのか\n"
    ++ "Unitテストよりも明瞭に記述できる。\n\n"
    ++ "しかし・・・"
  taka 
    $  "QuickCheckでは\n100%性質を\n保証する事が出来ない"
  -- 承 : 証明系でバグの無いプログラムを 
  slideTitle .= "証明による保証"
  big 
    $  "純粋な関数であれば、\n"
    ++ "「明らかな性質」を利用して、\n"
    ++ "数式のようにコードを変形し、\n"
    ++ "２つのコードが等価な事を示せる。"
  big 
    $  "手計算での証明については、\n"
    ++ "依然のダニーさんのスライド参照。"
  bigList
    [ "プログラムを書き換えられたらどうする？"
    , "「証明の正しさ」は誰が保証するの？"
    , "紙とペンだけで証明していくのは辛い"
    ]
  slideTitle .= "Coqを使おう"
  bigList
    [ "証明支援システム"
    , "純粋関数型プログラミング言語"
    , "無限再帰は×：非チューリング完全"
    , "CompCert : 証明付きCコンパイラ"
    ]
  twinBottom
    ( parCont
      $  "Haskellの時と同じ理屈で、\n"
      ++ "自然数と足し算を定義。"
    )
    ( codeCont 
      $  "Inductive nat : Type :=\n"
      ++ "  | O : nat\n"
      ++ "  | S : nat -> nat.\n\n"
      ++ "Fixpoint plus (n : nat) (m : nat) : nat :=\n"
      ++ "  match n with\n"
      ++ "    | O => m\n"
      ++ "    | S n' => S (plus n' m)\n"
      ++ "  end."
    )
  vertical
    [ parCont
      $  "もちろん、実行出来ます。"
    , codeCont
      $  "Coq < Eval compute in (plus (S(S O)) (S(S(S O)))).\n"
      ++ "     = S (S (S (S (S O))))\n"
      ++ "     : nat"
    ]
  twinBottom
    ( parCont
      $  "タクティクと呼ばれる命令を駆使して証明。\n"
      ++ "以下は左単位元則の例。"
    )
    ( codeCont $  "(* plusの定義により自明 *)\n"
      ++ "Lemma plus_0_n : forall n : nat, plus O n = n.\n"
      ++ "Proof.\n"
      ++ "  reflexivity.\n"
      ++ "Qed.\n"
    )
  taka "分からなくてもOK\nノリで見て行こう"
  twinBottom
    ( parCont
      $  "右単位元則の証明には、\n"
      ++ "数学的帰納法を使う必要がある。"
    )
    ( codeCont 
      $  "Theorem plus_n_0 : forall n : nat, plus n O = n.\n"
      ++ "Proof.\n"
      ++ "  intros. (* 量化子の解釈 *)\n"
      ++ "  induction n as [| n']. (* 数学的帰納法 *)\n"
      ++ "  reflexivity. (* 等価確認 *)\n"
      ++ "  simpl. (* 項簡約 *)\n"
      ++ "  rewrite -> IHn'. (* 帰納法の仮定による項書換え *)\n"
      ++ "  reflexivity. (*等価確認)\n"
      ++ "Qed.\n"
    )
  big
    $  "実際にはIDEの画面を使い\n"
    ++ "一手一手確認しながら証明を行う。\n"
    ++ "（パズルゲームのような感覚。)\n\n"
    ++ "考えるべき事は、\n"
    ++ "紙を使った証明とそんなに違わない。"
  big "詳しい方法は各自調べてね☆（ゝω・）v"
  slideTitle .= "Coqによる交換則の証明"
  twinBottom
    ( parCont
      $  "任意の自然数n, mについて、\n"
      ++ "succ (n + m) = n + succ m が成り立つ"
    )
    ( codeCont 
      $  "Lemma plus_n_Sm : forall n m : nat, S (plus n m) = plus n (S m).\n"
      ++ "Proof.\n"
      ++ "  intros.\n"
      ++ "  induction n as [| n'].\n"
      ++ "  reflexivity.\n"
      ++ "  simpl.\n"
      ++ "  rewrite -> IHn'.\n"
      ++ "  reflexivity.\n"
      ++ "Qed.  \n"
    )
  twinBottom
    ( parCont
      $  "先の補題や右単位元則を使って、\n"
      ++ "交換則を証明していく。"
    )
    ( codeCont
      $  "Theorem plus_comm : forall n m : nat, plus n m = plus m n.\n" ++ "Proof.\n"
      ++ "  intros.\n"
      ++ "  induction n as [| n'].\n"
      ++ "  simpl.  rewrite -> plus_n_0.  reflexivity.\n"
      ++ "  simpl.  rewrite <- plus_n_Sm.  rewrite -> IHn'.  reflexivity.\n"
      ++ "Qed.\n\n"
      ++ "(* これでplus関数が交換則を満たす事が完璧に保証された *)"
    )
  slideTitle .= "証明がもたらすもの"
  bigList
    [ "関数が性質を満たす事を100%保証"
    , "プログラムで精査されるため信頼できる" 
    , "修正により証明できなくなればすぐわかる"
    ] 
  slideTitle .= "ところで…"
  vertical
    [ parCont "実はこれ"
    , codeCont " Theorem plus_comm : forall n m : nat, plus n m = plus m n."
    , parCont "「型宣言」なんすよ！"
    ]
  slideTitle .= "型に関する高度な概念"
  vertical
    [ listCont
      [    "依存型：値を取って型を返す関数\n"
        ++ "　-> 型定義に値を書く事ができるようになる"
      ,    "全称量化子：型変数が任意の型を取れる表す\n"
        ++ "　-> Haskellでは通常、省略されている"
      ]
    , parCont2 
      $  "前章の内容と併せると、\n"
      ++ "型の表現力を上げるためにもこれらは有用"
    ]
  slideTitle .= "カリー・ハワード同型対応"
  big "えらいひと\n「あれ？型と理論って同じじゃね？」" 
  twinBottom
    ( parCont
      $  "命題を証明する事と、型に実装を与える事は、\n"
      ++ "同じであるという理論。"
    )
    ( codeCont
      $  "-- 三段論法\n"
      ++ "syllogism \n"
      ++ "  :: (b -> c) -- 全ての人間は死ぬ\n"
      ++ "  -> (a -> b) -- ソクラテスは人間である\n"
      ++ "  -> a -> c   -- よってソクラテスは死ぬ\n"
      ++ "syllogism f g x = f (g x)\n"
    )
  bigList
    [ "関数 (->) は「ならば」に対応"
    , "Eitherは「または」"
    , "Tupleは「かつ」"
    , "型レベルならばHaskellでも証明できる"
    ]
  big 
    $  "Coq等の証明支援系は、\n"
    ++ "この理論を利用する事によって、\n"
    ++ "機械的に命題を証明している。"
  -- 転 : 証明の抱える問題と妥協点
  -- 結 : プログラマは証明とこう向き合え 
  slideTitle .= "証明も万能ではない"
  bigList
    [ "証明系を良くしらないと使えない"
    , "命題の設定が難しい"
    , "全ての証明が可能なわけじゃない"
    , "証明系では完璧に証明出来ない命題もある"
    , "証明系そのものの正しさは誰が保証？"
    ]
  taka "まだまだ\nすぐに実用というわけには\nいかなそう…"
  big
    $  "証明自体が有益な技術である事に違いはない。\n\n"
    ++ "まずは正しく理解し、将来的には\n"
    ++ "適切なシーンで選択出来るよう！！"

aboutParadigm :: Taka () 
aboutParadigm = do
  -- 起 : 手続きの抱える曖昧性
  slideTitle .= "皆様"
  taka "突然ですが、\n手続きプログラミングを\nご存知ですか？"
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
  big
    $  "手続き自体がプリミティブな機能\n"
    ++ "というワケでは無い\n\n"
    ++ "では、どういう原理で、\n"
    ++ "実現しているのだろうか。"
  taka "そう"
  twinBottom
    ( takaCont "モナドだ！" )
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
  slideTitle .= "改めてモナドの定義を見てみる"
  twinBottom
    ( takaCont "完全に一致" )
    ( codeCont
      $  "class Monad m where\n"
      ++ "  (>>=)   :: m a -> (a -> m b) -> m b\n"
      ++ "  return  :: a -> m a\n\n"
      ++ "-- モナド則\n"
      ++ "return x >>= f == f x\n"
      ++ "m >>= return == m\n"
      ++ "(m >>= f) >>= g == m >>= (\\x -> f x >>= g)\n"
    )
  slideTitle .= "Haskellのモナドは型クラス"
  big
    $  "確かに。\n\n"
    ++ "「手続き」が多相である事は、\n"
    ++ "ポリモーフィズムの観点からから、\n"
    ++ "重要なポイントである事は間違いないが、\n"
    ++ "「正しさ」という観点からモナドを見たい。"
  -- 承 : 手続きの形式化手法としてのモナド
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
  bigList
    [ "これらが当てはまるものを「圏」と呼ぶ"
    , "圏から圏へ構造を維持した変換が関手"
    , "関手から関手への変換に自然変換がある"
    , "詳細を語ると３時間は喋れるので割愛"
    ]
  vertical
    [ listCont
      [ "型が対象"
      , "関数が射"
      , "関数合成が射の合成"
      , "id関数が恒等射"
      ]
    , parCont
      $  "のように当てはめる事で、\n"
      ++ "プログラミングの型は圏になる。"
    ]
  slideTitle .= "Wikipediaによるモナドの定義"
  big
    $  "自己関手 T : C -> C および、自然変換\n"
    ++ "η : 1_C -> T と μ : T^2 -> Tからなり、\n\n"
    ++ "μ○Tμ=μ○μ○\n"
    ++ "μ○Tη=μ○ηT=1_T\n\n"
    ++ "を満たすものをモナドと言う。"
  big
    $  "よく解らなくてもOK\nn"
    ++ "ηがreturn、μがjoinに対応する、\n"
    ++ "「雰囲気」がなんとなく伝わればOK"
  taka "とにかく\nモナドは圏論の言葉の\nプログラミングへの翻訳" 
  slideTitle .= "モナドは厳密"
  big 
    $  "プリミティブな手続き言語の愛用者には\n"
    ++ "モナドは冗長に感じるかもしれない。\n\n"
    ++ "しかし、モナドは圏論という、\n"
    ++ "数学的なバックグラウンドによって、\n"
    ++ "厳密に定式化する事が可能で、それにより\n"
    ++ "柔軟かつ大胆に操作する事が出来るのだ。"
  taka "「モナド」とは唯一\n手続きを正しく説明する事に\n成功した概念である"
  par "たぶん"
  -- 転 : HaskellらしいOOPの形式化手法とは
  slideTitle .= "OOPは定式化可能か"
  big
    $  "OOPの定式化自体は昔からの課題っぽい。\n\n" 
    ++ "これまでは、Haskellでも、\n"
    ++ "外部機能をラップする方針が\n"
    ++ "ほとんどだったが…"
  slideTitle .= "objective"
  twinBottom
    ( parCont
      $  "@fumievalさんによる\n" 
      ++ "比較的最近のOOPライブラリ。" 
    )
    ( codeCont
      $  "main :: IO ()\n"
      ++ "main = do \n"
      ++ "  str1 <- new $ stringObject \"Hoge\"\n"
      ++ "  str1.-PrintString\n"
      ++ "  str1.-SetString \"Foo\"\n"
      ++ "  str1.-PrintString\n"
      ++ "  x <- str1.-GetString\n"
      ++ "  putStrLn $ \"x = \" ++ x\n"
    )
  vertical
    [ parCont
      $  "使い方とか注意点とか、今回は多くは語りません\n\n"
      ++ "詳しくは発表者のブログへGo！"
    , parCont2
      $ "http://tune.hateblo.jp/entry/2015/03/27/035648"
    ]
  slideTitle .= "objectiveの特徴"
  vertical
    [ parCont "objectiveにとって、オブジェクトは単なる型"
    , codeCont
      $  "newtype Object f g\n"
      ++ "  = Object {runObject :: forall x. f x -> g (x, Object f g)}"
    , parCont 
      $  "曰く：ミーリマシンと自然変換を、\n"
      ++ "併せ持ったものが「オブジェクト」である。"
    ] 
  vertical
    [ parCont "ミーリマシン：自身の状態を持つ"
    , codeCont "newtype Mealy a b = Mealy a -> (b, Mealy a b)"
    , parCont "自然変換：関手から関手への自然な変換"
    , codeCont "forall x. f x -> g x"
    ]
  bigList
    [ "任意の関手がメッセージになる"
    , "即ちモナドもメッセージになる"
    , "どっちもたいへん形式的"
    ]
  big 
    $  "「オブジェクトの合成」という\n"
    ++ "演算を導入する事によって、\n"
    ++ "オブジェクトを射、メッセージを対象とし、\n"
    ++ "オブジェクトの合成を射の合成とした\n"
    ++ "＿人人人人人人＿\n"
    ++ "＞　圏になる　＜\n"
    ++ "￣Y^Y^Y^Y^Y￣\n"
  par "圏論の言葉を使ってOOPの設計ができるかも。"
  taka "とか、まぁ\n色々あるけど"
  slideTitle .= "とにかく"
  taka "objectiveは形式的！"
  -- 結 : 圏の言葉がパラダイムを正しく述べる
  slideTitle .= "圏論でパラダイムを述べる"
  big
    $  "スライド間に合わなかったので\n" 
    ++ "頑張って圏論の話をまとめる。" 

-- 結
summary :: Taka ()
summary = do
  slideTitle .= "まとめ"
  big
    $  "スライド間に合わなかったので。\n\n" 
    ++ "(1)〜(3)全てに\n" 
    ++ "型が深く関係しており、\n" 
    ++ "バグと戦うためには、\n" 
    ++ "型を良くしる事が不可欠だよ的な話。" 

-------------------------------------------------
-- helper 

setOptions :: Taka ()
setOptions = do
  slideFontSize .= Just 60
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
  codeOption.blockFontSize .= Just 40


-- 見出しページ付与
header :: String -> Taka () -> Taka ()
header s t = do
  stateSandbox $ do
    slideTitle .= ""
    slideFontSize .= Just 60
    taka2 s
  t

big :: String -> Taka () 
big s = do
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 80
    par s

bigList :: [String] -> Taka () 
bigList ss = do
  stateSandbox $ do
    contentsOption.blockFontSize .= Just 80
    list ss
