module Geister
  module LeaveRoom
    class Executor
      include ActiveModel::Model

      attr_accessor :player_entry

      def execute!
        ApplicationRecord.transaction do
          close_game if room.game && !room.game.close?

          room.status = :finished

          player_entry.user = nil

          room.save!
          player_entry.save!
        end
      end

      private

      def room
        @room ||= Room.includes(:player_entries, :game).find(player_entry.room.id)
      end

      def opponent_user
        room.player_entries.map(&:user).find { |user| user != player_entry.user }
      end

      def close_game
        room.game.status = :exited
        room.game.winner_user_id = opponent_user.id
        room.game.save!
      end
    end
  end
end
