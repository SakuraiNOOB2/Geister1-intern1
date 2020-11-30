require 'rails_helper'

describe Geister::DecideWinner do
  describe '#decide?' do
    let(:decide_winner) { described_class.new(pieces) }

    let(:user1_evil_pieces) do
      [
        create(:piece, point_x: 2, point_y: 2, kind: :evil, owner_user: user1),
        create(:piece, point_x: 2, point_y: 3, kind: :evil, owner_user: user1),
        create(:piece, point_x: 2, point_y: 4, kind: :evil, owner_user: user1),
        create(:piece, point_x: 2, point_y: 5, kind: :evil, owner_user: user1)
      ]
    end

    let(:user2_evil_pieces) do
      [
        create(:piece, point_x: 2, point_y: 2, kind: :evil, owner_user: user2),
        create(:piece, point_x: 2, point_y: 3, kind: :evil, owner_user: user2),
        create(:piece, point_x: 2, point_y: 4, kind: :evil, owner_user: user2),
        create(:piece, point_x: 2, point_y: 5, kind: :evil, owner_user: user2)
      ]
    end

    let(:user1_good_pieces) do
      [
        create(:piece, point_x: 2, point_y: 2, kind: :good, owner_user: user1),
        create(:piece, point_x: 2, point_y: 3, kind: :good, owner_user: user1),
        create(:piece, point_x: 2, point_y: 4, kind: :good, owner_user: user1),
        create(:piece, point_x: 2, point_y: 5, kind: :good, owner_user: user1)
      ]
    end

    let(:user2_good_pieces) do
      [
        create(:piece, point_x: 2, point_y: 2, kind: :good, owner_user: user2),
        create(:piece, point_x: 2, point_y: 3, kind: :good, owner_user: user2),
        create(:piece, point_x: 2, point_y: 4, kind: :good, owner_user: user2),
        create(:piece, point_x: 2, point_y: 5, kind: :good, owner_user: user2)
      ]
    end

    let(:pieces) do
      [
        user1_evil_pieces,
        user1_good_pieces,
        user2_evil_pieces,
        user2_good_pieces
      ].flatten
    end

    let(:user1) { create :user }
    let(:user2) { create :user }

    context 'when game not decide' do
      it { expect(decide_winner.decide?).to be_falsey }
    end

    context 'when user1 good piece captured all' do
      before do
        user1_good_pieces.each do |piece|
          piece.captured = true
          piece.save!
        end
      end

      it { expect(decide_winner.decide?).to be_truthy }
      it { expect(decide_winner.winner_user).to eq user2 }
    end

    context 'when user1 evil piece captured all' do
      before do
        user1_evil_pieces.each do |piece|
          piece.captured = true
          piece.save!
        end
      end

      specify { expect(decide_winner.decide?).to be_truthy }
      specify { expect(decide_winner.winner_user).to eq user1 }
    end

    context 'when user1 good piece gone to goal' do
      before do
        user1_good_pieces.first.tap do |piece|
          piece.point_x = 0
          piece.point_y = 1
          piece.save!
        end
      end

      it { expect(decide_winner.decide?).to be_truthy }
      it { expect(decide_winner.winner_user).to eq user1 }
    end
  end
end
