# convex

エクセルの便利ツールを提供する予定です．
現段階では，強調表示しかできません．

エクセルのシートに簡単に強調表示(塗りつぶし)を設定できます．
「強調文字」にセミコロンかカンマ区切りで入力した文字列を含むセルに対して，設定した「色」を着色できます．
複数ファイル，複数シートにも対応しています．

一度設定した後に，別のファイル，別の文字列，別の色で設定するときは，再読み込み(F5)してください．


## ネットのアプリを使う

次ののURLで使用できます．

https://matutosi.shinyapps.io/convex/

注意
- 使用したデータはセッション終了後に削除されるはずですが，機密情報は使用しないほうが良いかもしれません．   
- 使用時間の制限が月ごとにありますので，突然しようできないことがあるかもしれません．その場合は，Rをインストールして自分のパソコンで実行することをオススメします．   


## 自分のパソコンでの使用

Rをインストールしているときは，自分のパソコンでも実行できます．

```
  # install.packages(shiny)  # shinyをインストールしていない時
shiny::runGitHub("matutosi/convex", subdir = "R")
```

## 


松村 俊和 (2024) RとShinyを使ったエクセル便利ツール．https://matutosi.shinyapps.io/convex/ .

