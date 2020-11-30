require 'rails_helper'

describe Geister::PreparePiece::PieceKindValidator, type: :validator do
  describe '#validate' do
    subject { model_class.new(piece_preparations) }

    let(:model_class) do
      Struct.new(:piece_preparations) do
        include ActiveModel::Validations

        def self.name
          'DummyModel'
        end

        validates_with Geister::PreparePiece::PieceKindValidator
      end
    end

    let(:piece_preparations) do
      [
        Array.new(4) { build :geister_piece_preparation, kind: 'good' },
        Array.new(3) { build :geister_piece_preparation, kind: 'evil' },
        piece_preparation
      ].flatten
    end

    context 'when count of good and evil is 4' do
      let(:piece_preparation) { build :geister_piece_preparation, kind: 'evil' }

      it { is_expected.to be_valid }
    end

    context 'when count of good and evil is not 4' do
      let(:piece_preparation) { build :geister_piece_preparation, kind: 'good' }

      it { is_expected.not_to be_valid }
    end
  end
end
