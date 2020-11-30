require 'rails_helper'

describe Geister::PreparePiece::Executor do
  describe '#execute!' do
    subject { described_class.new(params).execute! }

    include_context 'piece_preparations'

    let(:params) { { game: game, user: user, piece_preparations: piece_preparations } }
    let(:game) { create :game, status: :preparing }
    let(:user) { game.first_mover_user }
    let(:piece_preparations) do
      (correct_first_piece_preparations[0..-2] << piece_preparation).compact
    end

    let(:piece_preparation) { attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 5, point_y: 2) }

    it { expect { subject }.not_to raise_error }
    it { expect { subject }.to change { Piece.count }.by(piece_preparations.count) }

    context 'when game be prepared' do
      before do
        described_class.new(
          user: game.last_mover_user,
          game: game,
          piece_preparations: correct_last_piece_preparations
        ).execute!
      end

      it 'should be game play_start!' do
        expect(game).to receive(:play_start!)
        subject
      end
    end

    context 'when piece count is not 8' do
      let(:piece_preparation) { nil }

      it { expect { subject }.to raise_error Errors::InvalidRequestParameter }
    end

    context 'when piece preparation kind is invalid' do
      let(:piece_preparation) { attributes_for(:geister_piece_preparation, kind: 'invalid', point_x: 5, point_y: 2) }

      it { expect { subject }.to raise_error Errors::InvalidRequestParameter }
    end

    context 'when piece preparation position be duplicate' do
      let(:piece_preparation) { attributes_for(:geister_piece_preparation, kind: 'invalid', point_x: 5, point_y: 1) }

      it { expect { subject }.to raise_error Errors::InvalidRequestParameter }
    end

    context 'when piece preparation position be out of range' do
      let(:piece_preparation) { attributes_for(:geister_piece_preparation, kind: 'invalid', point_x: 5, point_y: 3) }

      it { expect { subject }.to raise_error Errors::InvalidRequestParameter }
    end

    context 'when game is not preparing' do
      let(:game) { create :game, status: :playing }

      it { expect { subject }.to raise_error ActionController::BadRequest }
    end
  end
end
