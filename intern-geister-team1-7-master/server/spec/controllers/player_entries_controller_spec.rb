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

RSpec.describe PlayerEntriesController, type: :controller do
  include_context 'login'

  before { room.save }

  let(:room) { RoomFactory.new(first_user).create! }
  let(:first_user) { create :user }
  let(:find_first_player) { proc { PlayerEntry.find_by(room: room, index: 1) } }
  let(:find_last_player) { proc { PlayerEntry.find_by(room: room, index: 2) } }

  describe 'POST #create' do
    subject { post :create, params: { room_id: room.id } }

    let(:game_starter) { double('GameStarter') }

    context 'when not raise error' do
      it 'update second player with current_user and status is created' do
        expect(GameStarter).to receive(:new).and_return(game_starter)
        expect(game_starter).to receive(:start!)
        expect { subject }.to change { find_last_player.call.user_id }.from(nil).to(current_user.id)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when raise error' do
      before { allow_any_instance_of(Room).to receive(:enter_as_player!).and_raise(ActiveRecord::StaleObjectError) }

      it 'update second player with current_user and status is created' do
        expect { subject }.not_to change { find_last_player.call.user_id }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { room_id: room.id, id: player_entry.id } }

    let(:room) { create :room }
    let(:current_player_entry) { create :player_entry, user: current_user, room: room }
    let(:other_player_entry) { create :player_entry, :with_user, room: room }

    context 'when permission accepted' do
      let(:player_entry) { current_player_entry }

      it 'update second player user_id and status is success' do
        expect { subject }.to change { PlayerEntry.find(player_entry.id).user }.from(current_user).to(nil)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when permission denied' do
      let(:player_entry) { other_player_entry }

      it 'not update second player user_id and status is unauthorized' do
        expect { subject }.not_to change { PlayerEntry.find(player_entry.id) }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
