module Geister
  class DecideWinner
    attr_reader :winner_user

    def initialize(pieces)
      @pieces = pieces
      @users = pieces.group_by(&:owner_user).keys

      execute
    end

    def decide?
      winner_user.present?
    end

    private

    def execute
      which_one_evil_pieces_captured_all
      which_one_good_pieces_captured_all
      which_one_piece_reach_goal
    end

    def evil_pieces
      @pieces.select(&:evil?).group_by(&:owner_user)
    end

    def good_pieces
      @pieces.select(&:good?).group_by(&:owner_user)
    end

    def which_one_evil_pieces_captured_all
      evil_pieces.each do |user, pieces|
        @winner_user = user if pieces.all?(&:captured?)
      end
    end

    def which_one_good_pieces_captured_all
      good_pieces.each do |user, pieces|
        @winner_user = @users.find { |u| u != user } if pieces.all?(&:captured?)
      end
    end

    def which_one_piece_reach_goal
      reached_piece = @pieces.find(&:reach_goal?)

      return unless reached_piece

      @winner_user = reached_piece.owner_user
    end
  end
end
