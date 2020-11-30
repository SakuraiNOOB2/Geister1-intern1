# == Schema Information
#
# Table name: pieces
#
#  id            :integer          not null, primary key
#  point_x       :integer          not null
#  point_y       :integer          not null
#  owner_user_id :integer          not null
#  captured      :boolean          default(FALSE), not null
#  kind          :integer          default("good"), not null
#  game_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pieces_on_game_id        (game_id)
#  index_pieces_on_owner_user_id  (owner_user_id)
#

class Piece < ApplicationRecord
  belongs_to :owner_user, class_name: 'User'
  belongs_to :game

  enum kind: { good: 0, evil: 1 }

  KINDS = kinds.keys.freeze

  GOAL_OF_POINT_X_LIST = [0, 7].freeze
  GOAL_OF_POINT_Y_FOR_FIRST_MOVER_USER = 6
  GOAL_OF_POINT_Y_FOR_LAST_MOVER_USER = 1

  with_options presence: true do
    validates :point_x, inclusion: { in: 0..7 }
    validates :point_y, inclusion: { in: 1..6 }
    validates :owner_user
    validates :game
  end

  validates :captured, inclusion: { in: [true, false] }

  def exist_to_last_line?
    point_y == (
      game.first_mover_user?(owner_user) ? GOAL_OF_POINT_Y_FOR_FIRST_MOVER_USER : GOAL_OF_POINT_Y_FOR_LAST_MOVER_USER
    )
  end

  def reach_goal?
    return false unless point_x.in?(GOAL_OF_POINT_X_LIST)
    return false unless exist_to_last_line?

    true
  end
end
