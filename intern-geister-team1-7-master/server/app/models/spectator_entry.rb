# == Schema Information
#
# Table name: spectator_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spectator_entries_on_room_id              (room_id)
#  index_spectator_entries_on_user_id              (user_id)
#  index_spectator_entries_on_user_id_and_room_id  (user_id,room_id) UNIQUE
#

class SpectatorEntry < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: true, uniqueness: { scope: :user_id }
  validates :room_id, presence: true
end
