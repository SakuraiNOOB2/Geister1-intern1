module GeisterProtocol
  class Game < Protocol::Base
    STATUS = %w(preparing playing finished exited).freeze

    title 'game'
    description 'ゲーム情報'

    definition(
      :game_id,
      description: 'ゲームID',
      example: 1,
      type: Integer
    )

    definition(
      :turn_mover_user_id,
      description: '現在の手番ユーザのID',
      example: 1,
      type: Integer
    )

    definition(
      :turn_count,
      description: '現在のターン（ゲーム開始前は0）',
      example: 1,
      type: Integer
    )

    definition(
      :winner_user_id,
      description: '勝利ユーザのID(まだ勝敗が決まっていない場合は0)',
      example: 1,
      type: Integer,
      optional: true
    )

    definition(
      :first_mover_user_id,
      description: '先手ユーザのID',
      example: 1,
      type: Integer
    )

    definition(
      :last_mover_user_id,
      description: '後手ユーザのID',
      example: 2,
      type: Integer
    )

    definition(
      :status,
      description: "ゲーム状態 (#{STATUS.join(', ')} のいずれか。preparing: 準備中、playing: プレイ中、 finished: 決着、 exited: 相手が退出した)",
      example: STATUS.first,
      type: String
    )

    pieces_example = lambda do
      [1, 2].each_with_object([]) do |point_y, pieces|
        (2..5).each do |point_x|
          pieces << {
            point_x: point_x,
            point_y: point_y,
            kind: %w(good evil).fetch(point_x % 2)
          }
        end
      end
    end

    definition(
      :piece_preparations,
      example: pieces_example.call,
      items: {
        type: Hash,
        properties: {
          point_x: GeisterProtocol::Piece.ref(:point_x),
          point_y: GeisterProtocol::Piece.ref(:point_y),
          kind: GeisterProtocol::Piece.ref(:kind).merge(description: '駒の種類(good, evil)')
        }
      },
      type: Array
    )

    property :game_id, ref(:game_id)
    property :turn_mover_user_id, ref(:turn_mover_user_id)
    property :turn_count, ref(:turn_count)
    property :winner_user_id, ref(:winner_user_id)
    property :first_mover_user_id, ref(:first_mover_user_id)
    property :last_mover_user_id, ref(:last_mover_user_id)
    property :status, ref(:status)

    link(
      :show,
      description: 'ゲーム情報の取得',
      path: '/api/games/:game_id',
      target_schema: {
        game_id: ref(:game_id),
        turn_mover_user_id: ref(:turn_mover_user_id),
        turn_count: ref(:turn_count),
        winner_user_id: ref(:winner_user_id),
        first_mover_user_id: ref(:first_mover_user_id),
        last_mover_user_id: ref(:last_mover_user_id),
        status: ref(:status)
      }
    )

    link(
      :prepare,
      description: '駒の初期配置を送信する',
      path: '/api/games/:game_id/preparation',
      method: 'POST',
      rel: 'create',
      parameters: {
        piece_preparations: ref(:piece_preparations)
      },
      target_schema: {
        piece_preparations: ref(:piece_preparations)
      }
    )
  end
end
