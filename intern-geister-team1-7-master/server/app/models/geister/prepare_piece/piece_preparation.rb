module Geister
  module PreparePiece
    class PiecePreparation
      include ActiveModel::Model

      attr_accessor :point_x, :point_y, :kind, :game, :owner_user

      with_options presence: true do
        validates :game
        validates :owner_user
        validates :point_x, inclusion: { in: 2..5 }
        validates :point_y, inclusion: { in: [1, 2] }, if: :first_mover_user?
        validates :point_y, inclusion: { in: [5, 6] }, if: :last_mover_user?
        validates :kind, inclusion: { in: Piece::KINDS }
      end

      def save!
        validate! && Piece.create!(game: game, owner_user: owner_user, kind: kind, point_x: point_x, point_y: point_y)
      end

      def out_of_range?
        return false if valid?

        errors.details[:point_x].present? || errors.details[:point_y].present?
      end

      def wrong_kind?
        return false if valid?

        errors.details[:kind].present?
      end

      private

      def first_mover_user?
        game.first_mover_user?(owner_user)
      end

      def last_mover_user?
        game.last_mover_user?(owner_user)
      end
    end
  end
end
