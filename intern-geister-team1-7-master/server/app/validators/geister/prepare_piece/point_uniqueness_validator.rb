module Geister
  module PreparePiece
    class PointUniquenessValidator < ActiveModel::Validator
      def validate(model)
        return unless model&.piece_preparations

        compressed = model.piece_preparations.map { |param| [param.point_x, param.point_y] }.uniq

        model.errors.add(:piece_preparations, :point_duplicate) unless model.piece_preparations.size == compressed.size
      end
    end
  end
end
