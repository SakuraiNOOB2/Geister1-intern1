# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_rooms_on_game_id  (game_id)
#

class RoomSerializer < ApplicationSerializer
  attributes :room_id, :status, :owner_name, :created_at, :updated_at, :game_id

  def room_id
    object.id
  end
end
