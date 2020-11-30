# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  turn_count          :integer          default(0), not null
#  turn_mover_user_id  :integer          not null
#  first_mover_user_id :integer          not null
#  last_mover_user_id  :integer          not null
#  status              :integer          default("preparing"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lock_version        :integer          default(0), not null
#  winner_user_id      :integer
#
# Indexes
#
#  index_games_on_first_mover_user_id  (first_mover_user_id)
#  index_games_on_last_mover_user_id   (last_mover_user_id)
#  index_games_on_turn_mover_user_id   (turn_mover_user_id)
#  index_games_on_winner_user_id       (winner_user_id)
#

require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should define_enum_for(:status).with(%i(preparing playing finished exited)) }

  describe 'association' do
    it { should belong_to(:turn_mover_user).class_name('User') }
    it { should belong_to(:first_mover_user).class_name('User') }
    it { should belong_to(:last_mover_user).class_name('User') }
    it { should belong_to(:winner_user).class_name('User') }
    it { should have_one(:room) }
  end

  describe 'delegation' do
    let(:game) { create :game }
    let(:user) { game.first_mover_user }
    let(:piece_preparations) do
      Array.new(8) { attributes_for :geister_piece_preparation }
    end

    it 'should delegate method prepare_piece! to Geister' do
      expect(Geister).to receive(:prepare_piece!).with(user: user, game: game, piece_preparations: piece_preparations)
      game.prepare_piece!(user: user, piece_preparations: piece_preparations)
    end
  end

  describe 'validation' do
    it { should validate_presence_of(:turn_mover_user) }
    it { should validate_presence_of(:first_mover_user) }
    it { should validate_presence_of(:last_mover_user) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:turn_count) }
    it { should validate_numericality_of(:turn_count) }
  end

  describe 'before_validation' do
    subject { game.turn_mover_user }

    before { game.save! }

    let(:game) { create :game, first_mover_user: users.first, last_mover_user: users.last }
    let(:users) { create_list :user, 2 }

    it { is_expected.to eq users.first }
  end

  describe '#prepare_piece_completed?' do
    subject { game.prepare_piece_completed? }

    include_context 'piece_preparations'

    let(:game) { create :game, status: :preparing }

    context 'when piece preparing be completed' do
      before do
        game.prepare_piece!(user: game.first_mover_user, piece_preparations: correct_first_piece_preparations)
        game.prepare_piece!(user: game.last_mover_user, piece_preparations: correct_last_piece_preparations)
      end

      it { is_expected.to be_truthy }
    end

    context 'when piece preparing be not completed' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#play_start!' do
    subject { game.play_start! }
    let(:game) { create :game, status: status }

    context 'when game is preparing' do
      let(:status) { 'preparing' }

      it { expect { subject }.to change { game.status }.from(status).to('playing') }
      it { expect { subject }.to change { game.turn_count }.from(0).to(1) }
    end

    context 'when game is not preparing' do
      let(:status) { 'playing' }

      it { expect { subject }.to raise_error described_class::UnstartedError }
    end
  end

  describe '#next_turn!' do
    subject { game.next_turn! }

    let(:game) { create :game }

    it { expect { subject }.to change { game.turn_count }.by(1) }
    it { expect { subject }.to change { game.turn_mover_user }.from(game.first_mover_user).to(game.last_mover_user) }
  end

  describe '#finish_with_winner!' do
    subject { game.finish_with_winner!(winner) }

    let(:game) { create :game, status: :playing }
    let(:winner) { create :user }

    it { expect { subject }.to change { game.winner_user }.from(nil).to(winner) }
    it { expect { subject }.to change { game.status }.from('playing').to('finished') }
  end

  describe '#close?' do
    subject { game.close? }

    let(:game) { create :game, status: status }

    context 'when status is finished' do
      let(:status) { :finished }

      it { is_expected.to be_truthy }
    end

    context 'when status is exited' do
      let(:status) { :exited }

      it { is_expected.to be_truthy }
    end

    context 'when status is playing' do
      let(:status) { :playing }

      it { is_expected.to be_falsey }
    end
  end
end
