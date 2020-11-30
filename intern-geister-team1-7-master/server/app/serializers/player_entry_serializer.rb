# == Schema Information
#
# Table name: player_entries
#
#  id           :integer          not null, primary key
#  room_id      :integer          not null
#  user_id      :integer
#  index        :integer          not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_player_entries_on_room_id              (room_id)
#  index_player_entries_on_room_id_and_user_id  (room_id,user_id) UNIQUE
#  index_player_entries_on_user_id              (user_id)
#

class PlayerEntrySerializer < ApplicationSerializer
  attributes :player_entry_id, :room_id, :user_id

  def player_entry_id
    object.id
  end
end
