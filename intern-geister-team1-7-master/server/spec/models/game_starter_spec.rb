require 'rails_helper'

describe GameStarter, type: :model do
  describe '.start!' do
    before do
      create :player_entry, :with_user, room: room, index: 1
      create :player_entry, :with_user, room: room, index: 2
    end

    let(:starter) { described_class.new(room) }
    let(:room) { create :room }

    it 'should be create game and update room' do
      expect { starter.start! }.to change { Game.count }.from(0).to(1)

      game = Game.first
      player_entry_users = room.player_entries.map(&:user)
      mover_users = [game.first_mover_user, game.last_mover_user]

      expect(room.game).to eq game
      expect(room.status).to eq 'playing'
      expect(mover_users).to match_array player_entry_users
    end
  end
end
