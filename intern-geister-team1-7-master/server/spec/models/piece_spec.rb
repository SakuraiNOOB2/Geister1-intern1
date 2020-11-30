# == Schema Information
#
# Table name: pieces
#
#  id            :integer          not null, primary key
#  point_x       :integer          not null
#  point_y       :integer          not null
#  owner_user_id :integer          not null
#  captured      :boolean          default(FALSE), not null
#  kind          :integer          default("good"), not null
#  game_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pieces_on_game_id        (game_id)
#  index_pieces_on_owner_user_id  (owner_user_id)
#

require 'rails_helper'

RSpec.describe Piece, type: :model do
  it { should define_enum_for(:kind).with(%i(good evil)) }

  describe 'validation' do
    it { should belong_to(:owner_user).class_name('User') }
    it { should belong_to(:game) }
  end

  describe 'association' do
    it { should validate_presence_of(:point_x) }
    it { should validate_presence_of(:point_y) }
    it { should validate_inclusion_of(:point_x).in_array((0..7).to_a) }
    it { should validate_inclusion_of(:point_y).in_array((1..6).to_a) }
    it { should validate_presence_of(:owner_user) }
  end

  describe '#exist_to_last_line?' do
    subject { piece.exist_to_last_line? }

    let(:piece) { create :piece, point_y: point_y, point_x: 1, game: game }
    let(:game) { create :game }

    before { allow(game).to receive(:first_mover_user?).and_return(flag) }

    context 'when owner is first mover and exist to last line' do
      let(:flag) { true }
      let(:point_y) { 6 }

      it { is_expected.to be_truthy }
    end

    context 'when owner is first mover and not exist to last line' do
      let(:flag) { true }
      let(:point_y) { 1 }

      it { is_expected.to be_falsey }
    end

    context 'when owner is last mover and exist to last line' do
      let(:flag) { false }
      let(:point_y) { 1 }

      it { is_expected.to be_truthy }
    end

    context 'when owner is last mover and not exist to last line' do
      let(:flag) { false }
      let(:point_y) { 6 }

      it { is_expected.to be_falsey }
    end
  end

  describe '#reach_goal?' do
    subject { piece.reach_goal? }

    let(:piece) { create :piece, point_x: point_x, kind: kind, captured: captured }
    let(:point_x) { 0 }
    let(:captured) { false }
    let(:kind) { 'good' }
    let(:exist_to_last_line) { true }

    before { allow(piece).to receive(:exist_to_last_line?).and_return(exist_to_last_line) }

    context 'when exist to last line and point_x in goal list' do
      it { is_expected.to be_truthy }
    end

    context 'when not exist to last line' do
      let(:exist_to_last_line) { false }

      it { is_expected.to be_falsey }
    end

    context 'when exist to last line and point_x not in goal list' do
      let(:point_x) { 1 }

      it { is_expected.to be_falsey }
    end
  end
end
