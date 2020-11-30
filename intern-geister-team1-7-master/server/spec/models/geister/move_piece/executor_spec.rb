require 'rails_helper'

describe Geister::MovePiece::Executor do
  describe 'delegation' do
    it { should delegate_method(:game).to(:piece) }
  end

  describe '#execute!' do
    subject { described_class.new(params).execute! }

    let(:params) { { user: user, piece: piece, point_x: point_x, point_y: point_y } }
    let(:game) { create :game, first_mover_user: user, last_mover_user: other_user, status: :playing }

    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:piece) { create :piece, game: game, owner_user: user, point_x: 1, point_y: 1, kind: kind, captured: captured }

    let(:point_x) { 2 }
    let(:point_y) { 1 }
    let(:kind) { :good }
    let(:captured) { false }

    it { expect { subject }.to change { Piece.find(piece.id).point_x }.from(1).to(2) }
    it { expect { subject }.not_to change { Piece.find(piece.id).point_y } }
    it { expect { subject }.to change { game.turn_count }.by(1) }

    shared_examples_for 'raise error' do
      it 'should raise error and turn count not to change' do
        expect { expect { subject }.to raise_error Errors::InvalidRequestParameter }.not_to change { game.turn_count }
      end
    end

    context 'when user is not piece owner' do
      let(:piece) { create :piece, game: game, owner_user: other_user, point_x: 1, point_y: 1 }

      it_behaves_like 'raise error'
    end

    context 'when own piece exist in specify point' do
      before { create :piece, point_x: point_x, point_y: point_y, owner_user: user, game: game, captured: false }

      it_behaves_like 'raise error'
    end

    context 'when move distance is not one' do
      let(:point_x) { 2 }
      let(:point_y) { 2 }

      it_behaves_like 'raise error'
    end

    context 'when game is not playing' do
      let(:game) { create :game, status: :preparing }

      it_behaves_like 'raise error'
    end

    context 'when not good piece move to goal' do
      let(:kind) { :evil }

      [[1, 1], [6, 1], [1, 6], [6, 6]].each do |(x, y)|
        context "from (#{x}, #{y})" do
          let(:piece) do
            create :piece, game: game, owner_user: user, point_x: x, point_y: y, kind: kind, captured: false
          end
          let(:point_x) { x < 3 ? 0 : 7 }
          let(:point_y) { y }

          it_behaves_like 'raise error'
        end
      end
    end

    context 'when user is not turn mover user' do
      before { game.update!(turn_mover_user: other_user) }

      it_behaves_like 'raise error'
    end

    context 'when piece is captured' do
      let(:captured) { true }

      it_behaves_like 'raise error'
    end

    context 'when opponent piece exist' do
      before { create :piece, opponent_params }

      let(:opponent_params) { { game: game, point_x: point_x, point_y: point_y, owner_user: other_user } }

      it { expect { subject }.to change { Piece.find_by(opponent_params).captured? }.from(false).to(true) }
    end

    context 'when point specify out of range' do
      let(:piece) do
        create :piece, game: game, owner_user: user, point_x: 1, point_y: 2, kind: kind, captured: captured
      end

      let(:point_x) { 0 }
      let(:point_y) { 2 }

      it_behaves_like 'raise error'
    end

    context 'when piece move to goal' do
      let(:piece) do
        create :piece, game: game, owner_user: user, point_x: 1, point_y: 6, kind: kind, captured: captured
      end

      let(:point_x) { 0 }
      let(:point_y) { 6 }

      it { expect { subject }.to change { Piece.find(piece.id).point_x }.from(1).to(0) }
    end

    context 'when decide winner' do
      let(:room) { create :room, game: game, status: :playing }
      before do
        allow_any_instance_of(Geister::DecideWinner).to receive(:decide?).and_return(true)
        allow_any_instance_of(Geister::DecideWinner).to receive(:winner_user).and_return(winner)
      end

      let(:winner) { user }

      it 'should finish the game' do
        expect(game).to receive(:finish_with_winner!).with(winner)
        expect { subject }.to change { room.status }.from('playing').to('finished')
      end
    end
  end
end
