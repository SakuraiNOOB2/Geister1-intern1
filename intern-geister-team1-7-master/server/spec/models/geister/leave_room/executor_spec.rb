require 'rails_helper'

describe Geister::LeaveRoom::Executor do
  let(:executor) { described_class.new(player_entry: player_entry) }

  describe '#execute!' do
    subject { executor.execute! }

    context 'when enter full player(game is started)' do
      let(:room) { create :room, :with_full_player_entries, status: :playing }
      let(:player_entry) { room.player_entries.first }
      let(:other_player_entry) { room.player_entries.second }

      it { expect { subject }.to change { Room.find(room.id).status }.from('playing').to('finished') }
      it { expect { subject }.to change { Game.find(room.game.id).status }.to('exited') }
      it { expect { subject }.to change { Game.find(room.game.id).winner_user }.from(nil).to(other_player_entry.user) }
      it { expect { subject }.to change { PlayerEntry.find(player_entry.id).user }.from(player_entry.user).to(nil) }
    end

    context 'when enter one player(game is not started)' do
      let(:room) { create :room, status: :waiting }
      let(:player_entry) { create :player_entry, :with_user, room: room, index: 1 }

      it { expect { subject }.to change { Room.find(room.id).status }.from('waiting').to('finished') }
      it { expect { subject }.to change { PlayerEntry.find(player_entry.id).user }.from(player_entry.user).to(nil) }
    end

    context 'when leave second player after first player left' do
      let(:room) { create :room, :with_full_player_entries, status: :playing }
      let(:player_entry) { room.player_entries.second }

      before { described_class.new(player_entry: room.player_entries.first).execute! }

      it 'should not call #close_game' do
        expect(executor).not_to receive(:close_game)
        expect { subject }.not_to raise_error
      end
    end
  end
end
