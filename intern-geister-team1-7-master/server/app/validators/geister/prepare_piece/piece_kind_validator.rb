module Geister
  module PreparePiece
    class PieceKindValidator < ActiveModel::Validator
      KIND_COUNT = 4

      def validate(model)
        piece_preparations = model.piece_preparations

        model.errors.add(:piece_preparations, :wrong_kind_count) unless kind_count_be_correct_all?(piece_preparations)
      end

      private

      def kind_count_be_correct_all?(piece_preparations)
        return unless piece_preparations

        evils = piece_preparations&.select { |param| param.kind.to_s == 'evil' }
        goods = piece_preparations&.select { |param| param.kind.to_s == 'good' }

        evils.count == KIND_COUNT && goods.count == KIND_COUNT
      end
    end
  end
end
