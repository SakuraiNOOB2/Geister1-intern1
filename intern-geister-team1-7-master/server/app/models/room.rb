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

class Room < ApplicationRecord
  PLAYER_ENTRY_COUNT = 2

  after_initialize :set_default_value

  enum status: { waiting: 0, playing: 1, finished: 2 }

  has_many :player_entries, dependent: :delete_all
  has_many :spectator_entries, dependent: :delete_all

  belongs_to :game

  def owner_name
    player_entries.find { |pe| pe.index == 1 }&.user_name
  end

  def ready?
    player_entries.size == PLAYER_ENTRY_COUNT
  end

  def enter_as_player!(user)
    PlayerEntry.find_by(room: self, user: nil).tap do |entry|
      raise Errors::FullHouseError.new, "room #{id} is full house" unless entry

      entry.user = user
      entry.save!
    end
  end

  def enter_as_spectator!(user)
    SpectatorEntry.new(user: user, room: self).tap do |entry|
      entry.user = user
      entry.save!
    end
  end

  private

  def set_default_value
    self.status ||= :waiting
  end
end
