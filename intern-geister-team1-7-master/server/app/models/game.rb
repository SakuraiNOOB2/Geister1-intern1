# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  turn_count          :integer          default(0), not null
#  turn_mover_user_id  :integer          not null
#  first_mover_user_id :integer          not null
#  last_mover_user_id  :integer          not null
#  status              :integer          default("preparing"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lock_version        :integer          default(0), not null
#  winner_user_id      :integer
#
# Indexes
#
#  index_games_on_first_mover_user_id  (first_mover_user_id)
#  index_games_on_last_mover_user_id   (last_mover_user_id)
#  index_games_on_turn_mover_user_id   (turn_mover_user_id)
#  index_games_on_winner_user_id       (winner_user_id)
#

class Game < ApplicationRecord
  class UnstartedError < StandardError; end

  NUMBER_OF_COMPLETE_PIECE_COUNT = 16

  after_initialize :set_default_value
  before_validation(on: :create) { self.turn_mover_user = first_mover_user }

  enum status: { preparing: 0, playing: 1, finished: 2, exited: 3 }

  has_one :room
  has_many :pieces
  belongs_to :turn_mover_user, class_name: 'User'
  belongs_to :first_mover_user, class_name: 'User'
  belongs_to :last_mover_user, class_name: 'User'
  belongs_to :winner_user, class_name: 'User'

  validates :turn_mover_user, presence: true
  validates :first_mover_user, presence: true
  validates :last_mover_user, presence: true
  validates :status, presence: true
  validates :turn_count, presence: true, numericality: true

  def first_mover_user?(user)
    first_mover_user == user
  end

  def last_mover_user?(user)
    last_mover_user == user
  end

  def prepare_piece!(user:, piece_preparations:)
    Geister.prepare_piece!(game: self, user: user, piece_preparations: piece_preparations)
  end

  def prepare_piece_completed?
    pieces_owner_count_reached_player_entry_count? && piece_count_is_number_of_completed?
  end

  def play_start!
    raise UnstartedError.new, 'game is not preparing' unless preparing?
    self.turn_count = 1
    playing!
  end

  def enter_as_player?(user)
    room.player_entries.find { |entry| entry.user == user }.present?
  end

  def enter_as_spectator?(user)
    room.spectator_entries.find { |entry| entry.user == user }.present?
  end

  def entry?(user)
    enter_as_player?(user) || enter_as_spectator?(user)
  end

  def next_turn!
    update_attributes!(turn_count: turn_count + 1, turn_mover_user: next_turn_mover_user)
  end

  def next_turn_mover_user
    [first_mover_user, last_mover_user].find { |user| user != turn_mover_user }
  end

  def finish_with_winner!(winner)
    self.winner_user = winner
    finished!
  end

  def close?
    status.in?(%w(finished exited))
  end

  private

  def pieces_owner_count_reached_player_entry_count?
    pieces.includes(:owner_user).pluck(:name).uniq.count == Room::PLAYER_ENTRY_COUNT
  end

  def piece_count_is_number_of_completed?
    pieces.size == NUMBER_OF_COMPLETE_PIECE_COUNT
  end

  def set_default_value
    self.status ||= :preparing
    self.turn_count ||= 0
  end
end
