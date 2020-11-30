module Geister
  class << self
    def prepare_piece!(user:, game:, piece_preparations:)
      Geister::PreparePiece::Executor.new(game: game, user: user, piece_preparations: piece_preparations).execute!
    end

    def move_piece!(user:, piece:, point_y:, point_x:)
      Geister::MovePiece::Executor.new(user: user, piece: piece, point_y: point_y, point_x: point_x).execute!
    end

    def leave_room!(player_entry:)
      Geister::LeaveRoom::Executor.new(player_entry: player_entry).execute!
    end
  end
end
