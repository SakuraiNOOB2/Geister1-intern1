module Geister
  module MovePiece
    module ExecutorValidatable
      extend ActiveSupport::Concern

      included do
        with_options presence: true do
          validates :user
          validates :piece
          validates :point_y, inclusion: { in: 1..6 }
          validates :point_x, inclusion: { in: 1..6 }, unless: :piece_exist_to_last_line?
          validates :point_x, inclusion: { in: 0..7 }, if: :piece_exist_to_last_line?
        end

        validate :user_is_piece_owner
        validate :own_piece_not_exist
        validate :move_distance_is_one
        validate :game_is_playing
        validate :goal_piece_is_good
        validate :user_is_not_turn_mover_user
        validate :piece_is_not_captured
      end

      private

      def piece_exist_to_last_line?
        piece.exist_to_last_line?
      end

      def user_is_piece_owner
        errors.add(:user, :wrong_user) unless piece.owner_user == user
      end

      def own_piece_not_exist
        if Piece.find_by(game: game, point_x: point_x, point_y: point_y, owner_user: user, captured: false)
          errors.add(:piece, :own_piece_exist)
        end
      end

      def move_distance_is_one
        distance_x = (piece.point_x - point_x).abs
        distance_y = (piece.point_y - point_y).abs

        errors.add(:piece, :distance_is_not_one) unless (distance_x + distance_y) == 1
      end

      def game_is_playing
        errors.add(:game, :is_not_playing) unless game.playing?
      end

      def goal_piece_is_good
        return unless piece.dup.tap { |p| p.assign_attributes(point_x: point_x, point_y: point_y) }.reach_goal?

        errors.add(:piece, :goal_piece_is_not_good) unless piece.good?
      end

      def user_is_not_turn_mover_user
        errors.add(:user, :is_not_turn_mover_user) unless game.turn_mover_user == user
      end

      def piece_is_not_captured
        errors.add(:piece, :is_captured) if piece.captured?
      end
    end
  end
end
