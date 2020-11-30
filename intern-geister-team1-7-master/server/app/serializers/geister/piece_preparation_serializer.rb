module Geister
  class PiecePreparationSerializer < ActiveModel::Serializer
    attributes :point_y, :point_x, :kind
  end
end
