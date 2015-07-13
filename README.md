Takahashi Monad
==========================

## これは何

もともとは、高橋メソッドのスライドを簡単に作るためのハックとして、開発した言語内DSLです。
実際にしばらく運用して、作成スタイルをそのままに、もっと複雑なスライドを作成できると良いと考え、
本格的なスライドも作りたいなーと思って大幅にバージョンアップしました。

サンプル兼、ドキュメントのスライド：  
http://tokiwoousaka.github.io/takahashi/contents/20150213takahashi.html

上のスライドのソースコードです：  
https://gist.github.com/tokiwoousaka/b854bc054f7620cc5059

## インストール方法

stackを利用する事で、安全にインストールする事ができます。

詳しい方法は書いてるのでちょっと待っててね。

## 旧バージョンのインストール

※ この方法は最近のGHCでは動作しない可能性があります

Hackageにアップロード済の古いものをインストールする場合は、

```
$ cabal install takahashi
```

を実行。

もしくは、常に最新のものを使いたい場合、
本リポジトリをクローンして、`takahashi.cabal`の存在するディレクトリ上で、

```
$ cabal install
```

を実行する事で導入出来ます。
もし、sandboxを使わずに導入した場合、
`Control.Monad.Operational`や`Control.Lens`が他の同機能のライブラリと衝突する事があります、
その場合、ghc-pkgでどちらかを`hide`するで対応してください。

尚、本ライブラリは、LensおよびOperationalに、依存を最小限に抑えた小規模版を採用しています。

http://hackage.haskell.org/package/reasonable-lens  
http://hackage.haskell.org/package/reasonable-operational

