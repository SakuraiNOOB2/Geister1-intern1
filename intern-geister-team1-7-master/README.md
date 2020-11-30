# intern-geister

リポジトリはドキドキグルーヴワークスのインターン用ゲーム「ガイスター」の以下のリポジトリのコピーです。
https://github.com/dvd-dokidoki/intern-geister

インターン生が閲覧できるように用意しているのでunityフォルダ内はサンプルと最低限必要なクラスのみ入っており、これをもとにインターン生に開発を進めてもらう想定です

## VMのセットアップ

### VMの環境

詳しくは `build/package.json,setup.sh` の中を確認のこと。

- ubuntu-16.04.2-server-amd64
- rbenv, ruby-build
- ruby2.3.1
- mysql5.6

### requirements

下記をインストールする

- [packer](https://www.packer.io/) v1.0.0
- [virtualbox](https://www.virtualbox.org)

### build

下記のコマンドを実行

```bash
$ cd build
$ packer build package.json
```

- virtualboxの画面が立ち上がり、setupが始まるのでsuccessfullyが出るまで待つ
- 成功すれば `build/output-xxxx` 以下にovaファイルが出来ている

### 注意点

テンプレートリポジトリからcloneしているので、アクセス権限のないアカウントでbuildを実行すると失敗します

#### 対処法1

テンプレートから作成されたアクセス権限のある作業用リポジトリのURLに変更する
`build/setup.sh` 内の `REPOSITORY_URL` にURLを設定する

#### 対処法2

適宜見える場所にリポジトリを設置する
`build/setup.sh` 内の `REPOSITORY_URL` にURLを設定する

#### 対処法3

`build/setup.sh` 内の `REPOSITORY_URL` を空にした場合cloneは実行されないので、空に設定する
その場合、VM内にrepositoryをセットアップしたあとに下記を実行する

```bash
$ cd my_repository_path/server
$ bundle install -j4
$ bundle exec rails db:setup
$ bundle exec rails db:environment:set
```
