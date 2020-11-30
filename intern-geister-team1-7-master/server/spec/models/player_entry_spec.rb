# == Schema Information
#
# Table name: player_entries
#
#  id           :integer          not null, primary key
#  room_id      :integer          not null
#  user_id      :integer
#  index        :integer          not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_player_entries_on_room_id              (room_id)
#  index_player_entries_on_room_id_and_user_id  (room_id,user_id) UNIQUE
#  index_player_entries_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe PlayerEntry, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:room_id) }
    it { should validate_presence_of(:index) }
    it { should validate_inclusion_of(:index).in_array([1, 2]) }

    context 'uniqueness of index scoped_to room_id' do
      before { PlayerEntry.new(room_id: 1, index: 1).save }

      let(:same_set) { PlayerEntry.new(room_id: 1, index: 1) }
      let(:different_index) { PlayerEntry.new(room_id: 1, index: 2) }

      it { expect(same_set.save).to be_falsey }
      it { expect(different_index.save).to be_truthy }
    end

    context 'uniqueness of user_id scoped_to room_id' do
      before { PlayerEntry.new(room_id: 1, user_id: 1, index: 1).save }

      let(:same_id) { PlayerEntry.new(room_id: 1, user_id: 1, index: 2) }
      let(:nil_id) { PlayerEntry.new(room_id: 1, user_id: nil, index: 2) }

      it { expect(same_id.save).to be_falsey }
      it { expect(nil_id.save).to be_truthy }
    end
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end

  describe '#on_room_create' do
    subject { player_entry.send(:on_room_create?) }

    context 'when with not saved room' do
      before { room.player_entries << player_entry }

      let(:room) { build :room }
      let(:player_entry) { build :player_entry }

      it { is_expected.to be_truthy }
    end

    context 'when with saved room' do
      before { room.player_entries << player_entry }

      let(:room) { create :room }
      let(:player_entry) { build :player_entry }

      it { is_expected.to be_falsey }
    end

    context 'when room is nil' do
      let(:player_entry) { build :player_entry }

      it { is_expected.to be_falsey }
    end
  end
end
