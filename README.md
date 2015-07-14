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

stackを利用する事で、安全かつ簡単にインストールする事ができます。
基本的な使い方は以下の記事を参照すると良いでしょう。

http://qiita.com/tanakh/items/6866d0f570d0547df026  
http://tune.hateblo.jp/entry/2015/07/13/034148

対応しているsolverは`lts-2.18`です、詳細は以下のURLを参照してください。

https://www.stackage.org/lts-2.18

`stack.yaml`を以下のとおりに設定し…

```yaml
flags: {}
packages:
- '.'
extra-deps:
- monad-skeleton-0.1.2.1
- takahashi-0.2.2.0
resolver: lts-2.18
```

`cabal`ファイルの`build-depends`に`takahashi`を設定する事によって、
すぐに`Control.Monad.Takahashi`モジュールを使えるようになります。

## cabalを使ってインストール

※ この方法はGHCのバージョンによって動作しない可能性があります

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
