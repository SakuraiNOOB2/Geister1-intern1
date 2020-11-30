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

class PlayerEntry < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :room_id, presence: true
  validates :index, presence: true, inclusion: { in: [1, 2] }, uniqueness: { scope: [:room_id] }
  validates :user_id, uniqueness: { scope: :room_id, allow_nil: true }

  def user_name
    user&.name
  end

  private

  def on_room_create?
    return false if room.nil?
    return false unless room.new_record?

    true
  end
end
