require 'rails_helper'

describe Geister::PreparePiece::PiecePreparation, type: :model do
  describe 'validations' do
    subject { described_class.new(owner_user: user, game: game) }
    let(:game) { create :game }
    let(:user) { game.first_mover_user }

    context 'when owner_user is first_mover_user' do
      it { should validate_inclusion_of(:point_y).in_array([1, 2]) }
    end

    context 'when owner_user is last_mover_user' do
      let(:user) { game.last_mover_user }

      it { should validate_inclusion_of(:point_y).in_array([5, 6]) }
    end

    it { should validate_inclusion_of(:point_x).in_array([2, 3, 4, 5]) }
    it { should validate_inclusion_of(:kind).in_array(Piece::KINDS) }
  end
end
