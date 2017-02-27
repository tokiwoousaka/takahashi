module Day20170206otr(day20170206otr) where
import Control.Monad.Takahashi
import Control.Lens
import Common

day20170206otr :: IO ()
day20170206otr = do
  let fileName = "../contents/day20170206otr.html"
  writeSlide fileName presentation
  putStrLn $ "Sucess : Output to '" ++ fileName ++ "'"

presentation :: Taka ()
presentation = do
  setOptions
  stateSandbox $ do
    slideFontSize .= Just 60
    title "関数型ギークがOTRに転職して\nもうすぐ一年になるそうです" 
      $  "2017/2/27 ちゅーん(@its_out_of_tune)\n"
      ++ "for チョコ meets ワイン"
  slideTitle .= "自己紹介"
  profile

  header "はじめに" $ intrdaction
  header "ちゅーんさんは\nいかにしてギークになり\n社畜になり\nそしてニートになったのか" $ whyToNeet
  header "ちゅーんさんは\nいかにして名古屋化し\nどのように開発し\n学んでいるのか" $ whyNagoya
  header "ちゅーんさん自身が\nどう変わったのか\nどのようになりたいのか" $ detteiu

  slideTitle .= ""
  taka "ありがとうございました\nm(__)m"


profile :: Taka ()
profile = do
  stateSandbox $ do
    contentsOption2.blockFontSize .= Just 40
    twinLeft
      ( listCont
        [ "野生のHaskller(29♂)"
        , "2016年春よりなごやか"
        , "OTR 基盤チームの道化枠\n\n"
        , "スケボーできてない"
        , "ボルダリングできてない"
        , "スプラトゥーン えいえんのA帯"
        , "ゲーム実況とかはじめた"
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

intrdaction :: Taka ()
intrdaction = do
  taka "今日のおはなし"
  taka "自分語り"
  taka "です"
  taka "ご了承ください"
  taka "というわけで……"

whyToNeet :: Taka ()
whyToNeet = do
  slideTitle .= "誕生"
  taka "1987/7/23"
  taka "東京都\n(たしか)世田谷区のとある病院"
  taka "雷の鳴り響く\n嵐の夜に……"
  taka "資格ヲタクな父と\nゲームマニアな母"
  taka "ちゅーんさん\n爆誕"

  slideTitle .= "プログラミングとの出会い"
  taka "小学5年生になったある日"
  taka "父が遊んでいた\nVB5に興味"
  taka "おれ「これゲーム作れる？」\n父「作れるよ」\nおれ「じゃあやるわ」"
  taka "ずるずるとVB厨に"

  slideTitle .= "そして社畜へ……"
  taka "高校卒業後"
  taka "フリーターとか\n色々あって"
  taka "10年弱のVB歴を片手に"
  taka "小さな人材派遣会社"
  taka "えっちな社長と\n陽気な専務"
  taka "めっちゃ良い人達"
  taka "しかし\n仕事は客先常駐"
  taka "契約社員？出向？\nナニソレ"
  taka "通勤片道最大1.5h"
  taka "9:00am始業"
  taka "毎日23:00まで残業"
  taka "まぁ\nそれは良いとして"

  slideTitle .= "なっとくがいかない"
  taka "なっとくがいかない"
  taka "出来のわるい\n共通フレームワーク"
  taka "大量のボイラープレート"
  taka "数百行\n多い時には千行以上の\nメソッド"
  taka "アンチパターンの"
  taka "オ ン パ レ ー ド"
  taka "唯一\nクソコードを渡るための\n羅針盤"
  taka "膨大な量の\nエクセルドキュメント"
  taka "なぜなのか"

  slideTitle .= "そもそも向いてない"
  taka "そもそも向いてない"
  taka "協力会社の人間として\nもっと大事なこと"
  taka "社会人としての\n常識とか\nぜんぜんわからん"
  taka "根本的に"
  taka "事務的な仕事が\n超苦手"
  taka "エクセル資料を読むと死ぬ病"
  taka "客先常駐なので一人で孤立"
  taka "根本的な「仕事のしかた」を\n教えてくれる人はいない"
  taka "業績 最悪"
  taka "なんかもう"
  taka "ぜんぜん"
  taka "楽しくない"
  par "今思うと、かなりメンタルやられてたと思う"

  slideTitle .= "Haskellとの出会い"
  taka "丁度その頃"
  taka "Twitterで見かけた"
  taka "不思議なワード"
  taka "関数型言語"
  taka "関数型？\nCみたいにプロシージャを\n関数って呼ぶ言語のこと？"
  taka "Google先生\nつ「LISP」"
  taka "めっちゃシンプルな構文"
  taka "息をするように\n高階関数"
  taka "すごーい! \nなにこれなにこれ!!"
  taka "もっと関数型やりたい!!"
  taka "やるならナウい言語が良い\n-> Haskell"

  slideTitle .= "転職からニートへ"
  taka "Haskellの勉強を切っ掛けに"
  taka "関数型のコミュニティに\nがつがつ参加"
  taka "出会い"
  taka "高度な知識や\nスキルを武器に"
  taka "第一線で戦う人達"
  taka "俺はこのままで\n良いんだろうか……"
  taka "転職しよう!"
  taka "→都内の某\nソシャゲ開発会社へ"
  taka "一ヶ月後"
  taka "社長「おまえクビな」\nおれ「まじで」"

  slideTitle .= "よし、休もう!"
  taka "だいぶつらみが\n貯まっていたので"
  taka "親に甘えて"
  taka "がっつり休む事に"
  taka "無限に休んでも\nいられないので"
  taka "就職活動も兼ねて"
  taka "Haskellコミュニティには\n積極的に顔を出す"

whyNagoya :: Taka ()
whyNagoya = do
  slideTitle .= "そんな頃"
  taka "2015年某月某日"
  img HStretch "../img/04Yoneda/png001_yonedasc1.png"
  img HStretch "../img/04Yoneda/png002_yonedasc2.png"
  img HStretch "../img/04Yoneda/png003_yonedasc3.png"
  taka "当日"
  taka "米田の補題と\nOperationalの話"
  taka "詳細は\n当時の資料を見てね"
  taka "とにかく"
  taka "2016/04"
  taka "無事名古屋化"

  slideTitle .= "なにやってるの？"
  taka "基盤チーム"
  taka "共通フレームワーク"
  taka "ライブラリ"
  taka "更新、拡張、メンテナンス"
  taka "時々\n他案件のお手伝いとか"

  slideTitle .= "どんなふうに働いてるの？"
  taka "スクラムをベースに"
  taka "チームの生産性を\n最大化しながら……"
  twinBottom
    ( takaCont "言うは安し" )
    ( listCont2
        [ "透明性の高いチーム？"
        , "自己組織化？"
        , "機能横断的？"
        , "効果的なふりかえり？"
        ]
    )
  twinBottom
    ( takaCont "果てなき旅路" )
    ( listCont2
        [ "コストを最小に"
        , "効果を最大に"
        , "提供すべき価値は何か"
        , "提供できる価値は何か"
        , "最強のアジャイルチームとは？"
        ]
    )
  taka "なるほどわからん"
  taka "常に模索しながら働く"
  vertical
    [ takaCont "Q : すごい大変じゃないですか"
    , takaCont2 "A : はい。"
    ]

  slideTitle .= "これまでの仕事と違うこと"
  taka "これまでの仕事と\n違うこと"
  list
    [ "裁量の大きさ : 圧倒的モチベーションの差"
    , "チームで働く : 優秀な仲間が居る安心感"
    , "タスクの細分化 : 生産性の見える化"
    , "厳しいレビュー : 仕事の価値を評価"
    , "etc... 多すぎて語りきれない"
    ]
  taka "ひとつ上げるなら"
  taka "「チームで働く」"
  taka "だから出来ること"
  taka "苦手と向きあう\n土台がある"
  taka "例:"
  taka "チームメンバーの認識"
  taka "ちゅーんさんに\n膨大な情報を\n与えると死ぬ"
  taka "へーきへーき!\n得意なことは\nフレンズによって\n違うから!!"
  taka "できない事を\n無理して一人で抱えない"
  taka "ペア作業 :\n苦手を乗り越えるチャンス"
  vertical
    [ takaCont "Q : 以前と比較して\n良くなりましたか？"
    , takaCont2 "A : はい。"
    ]

detteiu :: Taka ()
detteiu = do
  slideTitle .= "どう変わったのか"
  taka "成長したこと"
  list
    [ "ホウレンソウの爆速化 : 30分も悩んでからでは遅い"
    , "作業見積り精度向上 : 計画外の再見積りはかなり正確に"
    , "品質に対する意識向上 : テストは十分か？"
    , "仕事上の無駄が激減 : こまめなタスクの見なおし"
    , "PO的な視点、スクラムマスター的な視点の習得"
    , ".NETやJenkins関連の知識++"
    , "etc. etc."
    ]

  slideTitle .= "課題"
  taka "まだまだ\n見積り精度がガバい"
  taka "自分自身の生産力に\n満足していない"
  taka "Haskellerのくせに"
  taka "関数型的な\n抽象化アプローチ"
  taka "が"
  taka "仕事に生かせてない"
  taka "とかとか"
  taka "問題は山積み"

  slideTitle .= "今後目指していきたい事"
  taka "身につけたいこと"
  taka "胸を張って\n売り出せる生産力"
  taka "自分が面白いと思う\nソリューションの\n積極的な採用"
  taka "自分の手で\n仕事を作れるだけの\nブランディング能力"
  taka "まぁ、気長にね\nσ(￣、￣=)"

  vertical
    [ takaCont "Q : 今、楽しいですか？"
    , takaCont2 "A : はい。"
    ]
