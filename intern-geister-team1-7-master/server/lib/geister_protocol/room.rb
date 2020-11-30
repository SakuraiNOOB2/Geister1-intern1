module GeisterProtocol
  class Room < Protocol::Base
    STATUS = %w(waiting playing finished).freeze

    title 'room'
    description 'ルーム情報'

    definition(
      :room_id,
      description: 'ルームID',
      example: 1,
      type: Integer
    )

    definition(
      :status,
      description: "ルーム状態（#{STATUS.join(',')}のいずれか。waiting: 対戦相手待ち、 playing: プレイ中、 fisnihed: 決着）",
      example: STATUS.first,
      type: String
    )

    definition :owner_name, GeisterProtocol::User.ref(:name)
    definition :game_id, GeisterProtocol::Game.ref(:game_id).merge(
      description: '部屋で行われるゲームのID(まだゲームが開始されていない時は0)'
    )

    definition(
      :created_at,
      description: 'ルームの作成日時',
      format: 'date-time',
      example: Time.gm(2016, 1, 1, 1).iso8601,
      type: Time
    )

    definition(
      :updated_at,
      description: 'ルームの更新日時',
      format: 'date-time',
      example: Time.gm(2016, 1, 1, 2).iso8601,
      type: Time
    )

    definition(
      :room,
      room_id: ref(:room_id),
      status: ref(:status),
      game_id: ref(:game_id),
      owner_name: ref(:owner_name),
      created_at: ref(:created_at),
      updated_at: ref(:updated_at)
    )

    room_example = lambda do |index|
      {
        room_id: index + 1,
        status: STATUS.rotate(index).first,
        owner_name: "owner#{('A'..'Z').to_a[index]}",
        game_id: index + 1,
        created_at: Time.gm(2016, 1, 1, index).iso8601,
        updated_at: Time.gm(2016, 1, 1, index + 1).iso8601
      }
    end

    definition(
      :rooms,
      description: 'list of room',
      example: Array.new(5) { |index| room_example.call(index) },
      items: {
        type: Hash,
        properties: ref(:room)
      },
      type: Array
    )

    property :room_id, ref(:room_id)
    property :status, ref(:status)
    property :owner_name, ref(:owner_name)
    property :game_id, ref(:game_id)
    property :created_at, ref(:created_at)
    property :updated_at, ref(:updated_at)

    link(
      :show,
      description: 'ルーム情報の取得',
      path: '/api/rooms/:room_id',
      target_schema: ref(:room)
    )

    # FIXME: roomのレスポンスがplayer_entry_idを返す必要があるためplayer_entryになっているが、roomに直したい
    link(
      :create,
      description: 'ルームの作成',
      path: '/api/rooms',
      target_schema: GeisterProtocol::PlayerEntry.ref(:player_entry)
    )

    link(
      :index,
      description: 'finishedでない全てのルーム情報の取得',
      path: '/api/rooms',
      target_schema: {
        rooms: ref(:rooms)
      }
    )
  end
end
