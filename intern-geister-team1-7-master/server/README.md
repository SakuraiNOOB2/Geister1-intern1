# API Server Document

## Installation

### Requirements

- [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

## Quick Start

### 0. docker-machine を使って、docker環境の入ったVMを作成する（ **初回のみ** ）

```
$ docker-machine create --driver virtualbox default # defaultは好きな名前でOK
```

### 1. 使用するdocker-machineの環境変数を読み込む

```
$ eval $(docker-machine env default) # docker-machineのマシン名
```

### 2. サーバのビルド

起動前にビルドが必要です。

```
$ docker-compose build
```

### 3. データベースのセットアップ

```
$ docker-compose up -d database # databaseは起動に少し時間が必要なので先に起動
$ docker-compose run webapi rails db:setup # databaseコンテナのデータベースをセットアップ
```

### 4. サーバの起動

productionモードのwebapiサーバがport3000で起動します

```
$ docker-compose up webapi
```

## その他

### mockの起動

port8080でmockサーバが起動する。

```
$ cd intern-geister/server
$ docker-compose -f docker-compose.mock.yml up

# GETの例
$ curl $(docker-machine ip default):8080/api/users/1

# POSTの例
$ curl -X POST -d "{\"name\": \"hoge\", \"password\":\"password\"}" -H "Content-Type: application/json" $(docker-machine ip default):8080/api/users
```

### development

developmentモードのwebapiサーバがport3000で起動います

developmentサーバにはこのディレクトリをマウントしてあるため、変更が即時反映されるようになっています

```
$ cd intern-geister/server
$ docker-compose up -d database
$ docker-compose run webapi rails db:setup
$ docker-compose -f docker-compose.development.yml up webapi
```

## JSON Schema

### ドキュメント

[こちら](schema.md)

### スキーマファイル

[こちら](schema.json)

### クライアント側のコード自動生成

```
$ docker-compose -f docker-compose.generator.yml run generator
```

### サーバ側のコード自動生成

Thingをリソース名（ `User` など）に変更する。

```
$ docker-compose -f docker-compose.generato.yml run rails generate json_schema:scaffold Thing --force
```
