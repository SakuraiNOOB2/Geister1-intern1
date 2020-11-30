module GeisterProtocol
  class PlayerEntry < Protocol::Base
    title 'player_entry'
    description 'ルームへのプレイヤーとしてのエントリー情報。ユーザは観戦者／プレイヤーあわせて1つのエントリーしか出来ない'

    definition(
      :player_entry_id,
      description: 'プレイヤーエントリーID',
      example: 1,
      type: Integer
    )

    definition :room_id, Room.ref(:room_id)
    definition :user_id, User.ref(:user_id)

    property :player_entry_id, ref(:player_entry_id)
    property :room_id, ref(:room_id)
    property :user_id, ref(:user_id)

    definition(
      :player_entry,
      player_entry_id: ref(:player_entry_id),
      room_id: ref(:room_id),
      user_id: ref(:user_id)
    )

    link(
      :create,
      description: 'ルームへプレイヤーとしてエントリーする',
      path: '/api/rooms/:room_id/player_entries',
      target_schema: ref(:player_entry)
    )

    link(
      :destroy,
      description: 'ルームへのプレイヤーエントリーを削除する（ルームから退出する）',
      path: '/api/player_entries/:player_entry_id',
      target_schema: ref(:player_entry)
    )
  end
end
