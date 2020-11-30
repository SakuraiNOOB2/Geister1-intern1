module GeisterProtocol
  class SpectatorEntry < Protocol::Base
    title 'spectator_entry'
    description 'ルームへの観戦者としてのエントリー情報。ユーザは観戦者／プレイヤーあわせて1つのエントリーしか出来ない'

    definition(
      :spectator_entry_id,
      description: '観戦者エントリーID',
      example: 1,
      type: Integer
    )

    property :spectator_entry_id, ref(:spectator_entry_id)

    link(
      :create,
      description: 'ルームへ観戦者としてエントリーする',
      path: '/api/rooms/:room_id/spectator_entries',
      target_schema: {
        spectator_entry_id: ref(:spectator_entry_id)
      }
    )

    link(
      :destroy,
      description: 'ルームへの観戦者エントリーを削除する（ルームから退出する）',
      path: '/api/spectator_entries/:spectator_entry_id',
      target_schema: {
        spectator_entry_id: ref(:spectator_entry_id)
      }
    )
  end
end
