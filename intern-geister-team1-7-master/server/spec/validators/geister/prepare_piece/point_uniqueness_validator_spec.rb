require 'rails_helper'

describe Geister::PreparePiece::PointUniquenessValidator do
  let(:model_class) do
    Struct.new(:piece_preparations) do
      include ActiveModel::Validations

      def self.name
        'DummyModel'
      end

      validates_with Geister::PreparePiece::PointUniquenessValidator
    end
  end

  describe '#validate' do
    subject { model_class.new(piece_preparations) }

    let(:piece_preparations) do
      [
        build(:geister_piece_preparation, point_x: 2, point_y: 1),
        build(:geister_piece_preparation, point_x: 3, point_y: 1),
        build(:geister_piece_preparation, point_x: 4, point_y: 1),
        build(:geister_piece_preparation, point_x: 5, point_y: 1),
        build(:geister_piece_preparation, point_x: 2, point_y: 2),
        build(:geister_piece_preparation, point_x: 3, point_y: 2),
        build(:geister_piece_preparation, point_x: 4, point_y: 2),
        piece_preparation
      ]
    end

    context 'when piece point is uniqueness' do
      let(:piece_preparation) { build :geister_piece_preparation, point_x: 5, point_y: 2 }

      it { is_expected.to be_valid }
    end

    context 'when piece point_x is duplicate' do
      let(:piece_preparation) { build :geister_piece_preparation, point_x: 4, point_y: 2 }

      it { is_expected.not_to be_valid }
    end

    context 'when piece point_y is duplicate' do
      let(:piece_preparation) { build :geister_piece_preparation, point_x: 5, point_y: 1 }

      it { is_expected.not_to be_valid }
    end
  end
end
