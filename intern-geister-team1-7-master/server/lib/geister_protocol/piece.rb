module GeisterProtocol
  class Piece < Protocol::Base
    KINDS = %w(good evil unknown).freeze

    title 'piece'
    description '駒情報'

    definition(
      :piece_id,
      description: '駒ID',
      example: 1,
      type: Integer
    )

    definition(
      :point_x,
      description: 'X座標（0~7） 先手ユーザから見て左が1。盤面は1~6だが、駒が盤外に出れるよう四隅のみ0と7が有効',
      example: 1,
      type: Integer
    )

    definition(
      :point_y,
      description: 'Y座標（1~6） 先手ユーザから見て下が1',
      example: 1,
      type: Integer
    )

    definition(
      :owner_user_id,
      description: '所有者のユーザID',
      example: 1,
      type: Integer
    )

    definition(
      :captured,
      description: '盤から除外されているか',
      example: false,
      type: [TrueClass, FalseClass]
    )

    definition(
      :kind,
      description: "駒の種類（#{KINDS.join(', ')})",
      example: KINDS.first,
      type: String
    )

    definition(
      :piece,
      piece_id: ref(:piece_id),
      point_x: ref(:point_x),
      point_y: ref(:point_y),
      owner_user_id: ref(:owner_user_id),
      captured: ref(:captured),
      kind: ref(:kind)
    )

    # 初期配置を返すようにする
    piece_example = lambda do
      index = 0
      [1, 2, 5, 6].each_with_object([]) do |point_y, pieces|
        (2..5).each do |point_x|
          index += 1
          pieces << {
            piece_id: index,
            point_x: point_x,
            point_y: point_y,
            owner_user_id: point_y.in?([5, 6]) ? 2 : 1,
            captured: false,
            kind: point_y.in?([5, 6]) ? 'unknown' : %w(good evil).fetch(point_x % 2)
          }
        end
      end
    end

    definition(
      :pieces,
      description: '駒一覧',
      example: piece_example.call,
      items: {
        type: Hash,
        properties: ref(:piece)
      },
      type: Array
    )

    property :piece_id, ref(:piece_id)
    property :point_x, ref(:point_x)
    property :point_y, ref(:point_y)
    property :owner_user_id, ref(:owner_user_id)
    property :captured, ref(:captured)
    property :kind, ref(:kind)

    link(
      :index,
      description: '駒一覧の取得',
      path: '/api/games/:game_id/pieces',
      target_schema: {
        pieces: ref(:pieces)
      }
    )

    link(
      :show,
      description: '駒情報の取得',
      path: '/api/pieces/:piece_id',
      target_schema: ref(:piece)
    )

    link(
      :update,
      description: '駒情報の更新（レスポンスは更新後の駒の情報）',
      path: '/api/pieces/:piece_id',
      parameters: {
        point_x: ref(:point_x),
        point_y: ref(:point_y)
      },
      target_schema: ref(:piece)
    )
  end
end
