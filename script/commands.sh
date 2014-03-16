#!/bin/sh

## 使い方の例なのですぐ終了
exit

## アプリからDLしてきたtxtファイルをdata/以下に移動
bash mv_file.sh

## 取得したデータをlibsvmで利用できるフォーマットに変換
## -s はsvmにかけるベクトルの次元数
## -o で指定したファイルへ出力。デフォルトでは traning_data.txt へ出力
python extract_svm_data.py  $(text-file-name) -s 27 

## data/ 以下のファイルをすべてかけるには
for txt in $(find data -name "*.txt"); do python extract_svm_data.py ${txt} -s 27 ; done

## 重複した行については以下のコマンドで削除する
sort training_data.txt | uniq > training_data.txt.tmp && mv training_data.txt.tmp training_data.txt

## かき集めた訓練データに対して、svnのモデルを生成
## デフォルトではsvm.model というファイルに書きだされる
python svm_train.py training_data.txt 


