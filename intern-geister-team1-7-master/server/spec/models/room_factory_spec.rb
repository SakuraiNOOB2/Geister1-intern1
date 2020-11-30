require 'rails_helper'

RSpec.describe RoomFactory, type: :model do
  describe '#create!' do
    subject { RoomFactory.new(user).create! }

    let(:user) { create :user }

    it 'should create room with two player_entries' do
      expect { subject }.to change { [Room.count, PlayerEntry.count] }
        .from([0, 0])
        .to([1, Room::PLAYER_ENTRY_COUNT])

      player_entry = Room.first.player_entries.find_by(index: 1)
      expect(player_entry.user).to eq user
    end
  end
end
