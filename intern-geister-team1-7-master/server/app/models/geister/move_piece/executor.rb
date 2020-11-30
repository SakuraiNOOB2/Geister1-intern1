module Geister
  module MovePiece
    class Executor
      include ActiveModel::Model
      include ExecutorValidatable

      attr_accessor :user, :piece, :point_y, :point_x

      delegate :game, to: :piece

      def point_y=(value)
        @point_y = value.to_i
      end

      def point_x=(value)
        @point_x = value.to_i
      end

      def execute!
        validate!

        ApplicationRecord.transaction do
          move_piece!
          capture_opponent_piece_if_exist!

          decide_winner.decide? ? finish_game_and_room! : gone_next_turn!
        end
      rescue ActiveModel::ValidationError
        raise Errors::InvalidRequestParameter, errors.full_messages.first
      end

      private

      def decide_winner
        Geister::DecideWinner.new(pieces)
      end

      def finish_game_and_room!
        game.finish_with_winner!(decide_winner.winner_user)
        game.room.finished!
      end

      def pieces
        game.pieces.each_with_object([]) do |piece, array|
          array << (self.piece == piece ? self.piece : piece)
        end
      end

      def gone_next_turn!
        game.next_turn!
      end

      def move_piece!
        piece.update_attributes!(point_y: point_y, point_x: point_x)
      end

      def capture_opponent_piece_if_exist!
        opponent_user = game.next_turn_mover_user
        opponent_piece = Piece.find_by(game: game, owner_user: opponent_user, point_y: point_y, point_x: point_x)
        return unless opponent_piece

        opponent_piece.update_attributes!(captured: true)
      end
    end
  end
end
