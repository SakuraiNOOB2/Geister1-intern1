# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_rooms_on_game_id  (game_id)
#

require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should define_enum_for(:status).with([:waiting, :playing, :finished]) }

  describe 'association' do
    it { should have_many(:player_entries).dependent(:delete_all) }
    it { should have_many(:spectator_entries).dependent(:delete_all) }
    it { should belong_to(:game) }
  end

  describe '#ready?' do
    subject { room.ready? }

    let(:room) { create :room }

    context 'when player_entries reached MAX_PLAYER_COUNT' do
      before do
        create :player_entry, :with_user, index: 1, room: room
        create :player_entry, :with_user, index: 2, room: room
      end

      it { is_expected.to be_truthy }
    end

    context 'when player_entries not reached MAX_PLAYER_COUNT' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#enter_as_player!' do
    subject { room.enter_as_player!(current_user) }

    let!(:first_user) { create :user }
    let!(:current_user) { create :user }
    let!(:room) { RoomFactory.new(first_user).create! }

    context 'when not raise full house error' do
      it 'should enter to room as player2' do
        expect { subject }.to change { PlayerEntry.find_by(index: 2, room: room).user }.from(nil).to(current_user)
      end
    end

    context 'when raise full house error' do
      before { room.enter_as_player!(other_user) }

      let!(:other_user) { create :user }

      it 'should enter to room as player2' do
        expect { subject }.to raise_error Errors::FullHouseError
      end
    end
  end

  describe '#enter_as_spectator!' do
    subject { room.enter_as_spectator!(current_user) }

    let!(:first_user) { create :user }
    let!(:current_user) { create :user }
    let!(:room) { RoomFactory.new(first_user).create! }

    it 'should enter to room as spectator' do
      expect { subject }.to change { SpectatorEntry.where(user: current_user).count }.by(1)
    end
  end
end
