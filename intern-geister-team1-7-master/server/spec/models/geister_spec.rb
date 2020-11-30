require 'rails_helper'

describe Geister do
  describe '.prepare_piece!' do
    subject { described_class.prepare_piece!(params) }

    include_context 'piece_preparations'

    let(:game) { create :game }
    let(:user) { game.first_mover_user }
    let(:params) { { game: game, user: user, piece_preparations: correct_first_piece_preparations } }
    let(:prepare_piece) { double('PreparePiece') }

    it 'should be delegate to Geister::PreparePiece' do
      expect(Geister::PreparePiece::Executor).to receive(:new).with(params).and_return(prepare_piece)
      expect(prepare_piece).to receive(:execute!)
      subject
    end
  end
end
