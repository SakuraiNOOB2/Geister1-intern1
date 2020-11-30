# API for Geister
API for Geister in DOKIDOKI GROOVEWORKS

* [game](#game)
  * [GET /api/games/:game_id](#get-apigamesgame_id)
  * [POST /api/games/:game_id/preparation](#post-apigamesgame_idpreparation)
* [piece](#piece)
  * [GET /api/games/:game_id/pieces](#get-apigamesgame_idpieces)
  * [GET /api/pieces/:piece_id](#get-apipiecespiece_id)
  * [PUT /api/pieces/:piece_id](#put-apipiecespiece_id)
* [player_entry](#player_entry)
  * [POST /api/rooms/:room_id/player_entries](#post-apiroomsroom_idplayer_entries)
  * [DELETE /api/player_entries/:player_entry_id](#delete-apiplayer_entriesplayer_entry_id)
* [room](#room)
  * [GET /api/rooms/:room_id](#get-apiroomsroom_id)
  * [POST /api/rooms](#post-apirooms)
  * [GET /api/rooms](#get-apirooms)
* [spectator_entry](#spectator_entry)
  * [POST /api/rooms/:room_id/spectator_entries](#post-apiroomsroom_idspectator_entries)
  * [DELETE /api/spectator_entries/:spectator_entry_id](#delete-apispectator_entriesspectator_entry_id)
* [user](#user)
  * [GET /api/users/:user_id](#get-apiusersuser_id)
  * [POST /api/users](#post-apiusers)
* [user_session](#user_session)
  * [POST /api/user_sessions](#post-apiuser_sessions)
  * [DELETE /api/user_sessions/:user_session_id](#delete-apiuser_sessionsuser_session_id)

## game
ゲーム情報

### Properties
* game_id
  * ゲームID
  * Example: `1`
  * Type: integer
* turn_mover_user_id
  * 現在の手番ユーザのID
  * Example: `1`
  * Type: integer
* turn_count
  * 現在のターン（ゲーム開始前は0）
  * Example: `1`
  * Type: integer
* winner_user_id
  * 勝利ユーザのID(まだ勝敗が決まっていない場合は0)
  * Example: `1`
  * Type: integer
* first_mover_user_id
  * 先手ユーザのID
  * Example: `1`
  * Type: integer
* last_mover_user_id
  * 後手ユーザのID
  * Example: `2`
  * Type: integer
* status
  * ゲーム状態 (preparing, playing, finished, exited のいずれか。preparing: 準備中、playing: プレイ中、 finished: 決着、 exited: 相手が退出した)
  * Example: `"preparing"`
  * Type: string

### GET /api/games/:game_id
ゲーム情報の取得

```
GET /api/games/:game_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "game_id": 1,
  "turn_mover_user_id": 1,
  "turn_count": 1,
  "winner_user_id": 1,
  "first_mover_user_id": 1,
  "last_mover_user_id": 2,
  "status": "preparing"
}
```

### POST /api/games/:game_id/preparation
駒の初期配置を送信する

* piece_preparations
  * Example: `[{"point_x"=>2, "point_y"=>1, "kind"=>"good"}, {"point_x"=>3, "point_y"=>1, "kind"=>"evil"}, {"point_x"=>4, "point_y"=>1, "kind"=>"good"}, {"point_x"=>5, "point_y"=>1, "kind"=>"evil"}, {"point_x"=>2, "point_y"=>2, "kind"=>"good"}, {"point_x"=>3, "point_y"=>2, "kind"=>"evil"}, {"point_x"=>4, "point_y"=>2, "kind"=>"good"}, {"point_x"=>5, "point_y"=>2, "kind"=>"evil"}]`
  * Type: array

```
POST /api/games/:game_id/preparation HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "piece_preparations": [
    {
      "point_x": 2,
      "point_y": 1,
      "kind": "good"
    },
    {
      "point_x": 3,
      "point_y": 1,
      "kind": "evil"
    },
    {
      "point_x": 4,
      "point_y": 1,
      "kind": "good"
    },
    {
      "point_x": 5,
      "point_y": 1,
      "kind": "evil"
    },
    {
      "point_x": 2,
      "point_y": 2,
      "kind": "good"
    },
    {
      "point_x": 3,
      "point_y": 2,
      "kind": "evil"
    },
    {
      "point_x": 4,
      "point_y": 2,
      "kind": "good"
    },
    {
      "point_x": 5,
      "point_y": 2,
      "kind": "evil"
    }
  ]
}
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "piece_preparations": [
    {
      "point_x": 2,
      "point_y": 1,
      "kind": "good"
    },
    {
      "point_x": 3,
      "point_y": 1,
      "kind": "evil"
    },
    {
      "point_x": 4,
      "point_y": 1,
      "kind": "good"
    },
    {
      "point_x": 5,
      "point_y": 1,
      "kind": "evil"
    },
    {
      "point_x": 2,
      "point_y": 2,
      "kind": "good"
    },
    {
      "point_x": 3,
      "point_y": 2,
      "kind": "evil"
    },
    {
      "point_x": 4,
      "point_y": 2,
      "kind": "good"
    },
    {
      "point_x": 5,
      "point_y": 2,
      "kind": "evil"
    }
  ]
}
```

## piece
駒情報

### Properties
* piece_id
  * 駒ID
  * Example: `1`
  * Type: integer
* point_x
  * X座標（0~7） 先手ユーザから見て左が1。盤面は1~6だが、駒が盤外に出れるよう四隅のみ0と7が有効
  * Example: `1`
  * Type: integer
* point_y
  * Y座標（1~6） 先手ユーザから見て下が1
  * Example: `1`
  * Type: integer
* owner_user_id
  * 所有者のユーザID
  * Example: `1`
  * Type: integer
* captured
  * 盤から除外されているか
  * Example: `false`
  * Type: boolean
* kind
  * 駒の種類（good, evil, unknown)
  * Example: `"good"`
  * Type: string

### GET /api/games/:game_id/pieces
駒一覧の取得

```
GET /api/games/:game_id/pieces HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "pieces": [
    {
      "piece_id": 1,
      "point_x": 2,
      "point_y": 1,
      "owner_user_id": 1,
      "captured": false,
      "kind": "good"
    },
    {
      "piece_id": 2,
      "point_x": 3,
      "point_y": 1,
      "owner_user_id": 1,
      "captured": false,
      "kind": "evil"
    },
    {
      "piece_id": 3,
      "point_x": 4,
      "point_y": 1,
      "owner_user_id": 1,
      "captured": false,
      "kind": "good"
    },
    {
      "piece_id": 4,
      "point_x": 5,
      "point_y": 1,
      "owner_user_id": 1,
      "captured": false,
      "kind": "evil"
    },
    {
      "piece_id": 5,
      "point_x": 2,
      "point_y": 2,
      "owner_user_id": 1,
      "captured": false,
      "kind": "good"
    },
    {
      "piece_id": 6,
      "point_x": 3,
      "point_y": 2,
      "owner_user_id": 1,
      "captured": false,
      "kind": "evil"
    },
    {
      "piece_id": 7,
      "point_x": 4,
      "point_y": 2,
      "owner_user_id": 1,
      "captured": false,
      "kind": "good"
    },
    {
      "piece_id": 8,
      "point_x": 5,
      "point_y": 2,
      "owner_user_id": 1,
      "captured": false,
      "kind": "evil"
    },
    {
      "piece_id": 9,
      "point_x": 2,
      "point_y": 5,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 10,
      "point_x": 3,
      "point_y": 5,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 11,
      "point_x": 4,
      "point_y": 5,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 12,
      "point_x": 5,
      "point_y": 5,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 13,
      "point_x": 2,
      "point_y": 6,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 14,
      "point_x": 3,
      "point_y": 6,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 15,
      "point_x": 4,
      "point_y": 6,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    },
    {
      "piece_id": 16,
      "point_x": 5,
      "point_y": 6,
      "owner_user_id": 2,
      "captured": false,
      "kind": "unknown"
    }
  ]
}
```

### GET /api/pieces/:piece_id
駒情報の取得

```
GET /api/pieces/:piece_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "piece_id": 1,
  "point_x": 1,
  "point_y": 1,
  "owner_user_id": 1,
  "captured": false,
  "kind": "good"
}
```

### PUT /api/pieces/:piece_id
駒情報の更新（レスポンスは更新後の駒の情報）

* point_x
  * X座標（0~7） 先手ユーザから見て左が1。盤面は1~6だが、駒が盤外に出れるよう四隅のみ0と7が有効
  * Example: `1`
  * Type: integer
* point_y
  * Y座標（1~6） 先手ユーザから見て下が1
  * Example: `1`
  * Type: integer

```
PUT /api/pieces/:piece_id HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "point_x": 1,
  "point_y": 1
}
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "piece_id": 1,
  "point_x": 1,
  "point_y": 1,
  "owner_user_id": 1,
  "captured": false,
  "kind": "good"
}
```

## player_entry
ルームへのプレイヤーとしてのエントリー情報。ユーザは観戦者／プレイヤーあわせて1つのエントリーしか出来ない

### Properties
* player_entry_id
  * プレイヤーエントリーID
  * Example: `1`
  * Type: integer
* room_id
  * ルームID
  * Example: `1`
  * Type: integer
* user_id
  * ユーザID
  * Example: `1`
  * Type: integer

### POST /api/rooms/:room_id/player_entries
ルームへプレイヤーとしてエントリーする

```
POST /api/rooms/:room_id/player_entries HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "player_entry_id": 1,
  "room_id": 1,
  "user_id": 1
}
```

### DELETE /api/player_entries/:player_entry_id
ルームへのプレイヤーエントリーを削除する（ルームから退出する）

```
DELETE /api/player_entries/:player_entry_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "player_entry_id": 1,
  "room_id": 1,
  "user_id": 1
}
```

## room
ルーム情報

### Properties
* room_id
  * ルームID
  * Example: `1`
  * Type: integer
* status
  * ルーム状態（waiting,playing,finishedのいずれか。waiting: 対戦相手待ち、 playing: プレイ中、 fisnihed: 決着）
  * Example: `"waiting"`
  * Type: string
* owner_name
  * ユーザ名(英数字4文字以上16文字以下)
  * Example: `"alice"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{4,16}\Z/`
* game_id
  * 部屋で行われるゲームのID(まだゲームが開始されていない時は0)
  * Example: `1`
  * Type: integer
* created_at
  * ルームの作成日時
  * Example: `"2016-01-01T01:00:00Z"`
  * Type: string
  * Format: date-time
* updated_at
  * ルームの更新日時
  * Example: `"2016-01-01T02:00:00Z"`
  * Type: string
  * Format: date-time

### GET /api/rooms/:room_id
ルーム情報の取得

```
GET /api/rooms/:room_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "room_id": 1,
  "status": "waiting",
  "game_id": 1,
  "owner_name": "alice",
  "created_at": "2016-01-01T01:00:00Z",
  "updated_at": "2016-01-01T02:00:00Z"
}
```

### POST /api/rooms
ルームの作成

```
POST /api/rooms HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "player_entry_id": 1,
  "room_id": 1,
  "user_id": 1
}
```

### GET /api/rooms
finishedでない全てのルーム情報の取得

```
GET /api/rooms HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "rooms": [
    {
      "room_id": 1,
      "status": "waiting",
      "owner_name": "ownerA",
      "game_id": 1,
      "created_at": "2016-01-01T00:00:00Z",
      "updated_at": "2016-01-01T01:00:00Z"
    },
    {
      "room_id": 2,
      "status": "playing",
      "owner_name": "ownerB",
      "game_id": 2,
      "created_at": "2016-01-01T01:00:00Z",
      "updated_at": "2016-01-01T02:00:00Z"
    },
    {
      "room_id": 3,
      "status": "finished",
      "owner_name": "ownerC",
      "game_id": 3,
      "created_at": "2016-01-01T02:00:00Z",
      "updated_at": "2016-01-01T03:00:00Z"
    },
    {
      "room_id": 4,
      "status": "waiting",
      "owner_name": "ownerD",
      "game_id": 4,
      "created_at": "2016-01-01T03:00:00Z",
      "updated_at": "2016-01-01T04:00:00Z"
    },
    {
      "room_id": 5,
      "status": "playing",
      "owner_name": "ownerE",
      "game_id": 5,
      "created_at": "2016-01-01T04:00:00Z",
      "updated_at": "2016-01-01T05:00:00Z"
    }
  ]
}
```

## spectator_entry
ルームへの観戦者としてのエントリー情報。ユーザは観戦者／プレイヤーあわせて1つのエントリーしか出来ない

### Properties
* spectator_entry_id
  * 観戦者エントリーID
  * Example: `1`
  * Type: integer

### POST /api/rooms/:room_id/spectator_entries
ルームへ観戦者としてエントリーする

```
POST /api/rooms/:room_id/spectator_entries HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "spectator_entry_id": 1
}
```

### DELETE /api/spectator_entries/:spectator_entry_id
ルームへの観戦者エントリーを削除する（ルームから退出する）

```
DELETE /api/spectator_entries/:spectator_entry_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "spectator_entry_id": 1
}
```

## user
ユーザ情報

### Properties
* user_id
  * ユーザID
  * Example: `1`
  * Type: integer
* name
  * ユーザ名(英数字4文字以上16文字以下)
  * Example: `"alice"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{4,16}\Z/`
* password
  * パスワード（英数字8文字以上16文字以下）
  * Example: `"password1234"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{8,16}\Z/`
* created_at
  * ユーザの作成日時
  * Example: `"2016-01-01T00:00:00Z"`
  * Type: string
  * Format: date-time
* updated_at
  * ユーザの更新日時
  * Example: `"2016-01-01T00:00:00Z"`
  * Type: string
  * Format: date-time

### GET /api/users/:user_id
ユーザ情報の取得

```
GET /api/users/:user_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 1,
  "name": "alice",
  "created_at": "2016-01-01T00:00:00Z",
  "updated_at": "2016-01-01T00:00:00Z"
}
```

### POST /api/users
ユーザの作成

* name
  * ユーザ名(英数字4文字以上16文字以下)
  * Example: `"alice"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{4,16}\Z/`
* password
  * パスワード（英数字8文字以上16文字以下）
  * Example: `"password1234"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{8,16}\Z/`

```
POST /api/users HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "name": "alice",
  "password": "password1234"
}
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "user_id": 1,
  "name": "alice",
  "created_at": "2016-01-01T00:00:00Z",
  "updated_at": "2016-01-01T00:00:00Z"
}
```

## user_session
ユーザセッション情報。ユーザの作成とログイン以外の全てのリクエストはログインしている必要がある。ユーザセッションを作成することでログイン、削除することでログアウトの処理を行える。

### Properties

### POST /api/user_sessions
ユーザセッションの作成（ログイン）

* name
  * ユーザ名(英数字4文字以上16文字以下)
  * Example: `"alice"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{4,16}\Z/`
* password
  * パスワード（英数字8文字以上16文字以下）
  * Example: `"password1234"`
  * Type: string
  * Pattern: `/\A[a-zA-Z0-9]{8,16}\Z/`

```
POST /api/user_sessions HTTP/1.1
Content-Type: application/json
Host: api.example.com

{
  "name": "alice",
  "password": "password1234"
}
```

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "user_session_id": 1,
  "access_token": "f9425bc7de66d2e78de46a53",
  "user_id": 1
}
```

### DELETE /api/user_sessions/:user_session_id
ユーザセッションの削除（ログアウト）

```
DELETE /api/user_sessions/:user_session_id HTTP/1.1
Host: api.example.com
```

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user_id": 1,
  "name": "alice",
  "created_at": "2016-01-01T00:00:00Z",
  "updated_at": "2016-01-01T00:00:00Z"
}
```

