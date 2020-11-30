# == Schema Information
#
# Table name: spectator_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spectator_entries_on_room_id              (room_id)
#  index_spectator_entries_on_user_id              (user_id)
#  index_spectator_entries_on_user_id_and_room_id  (user_id,room_id) UNIQUE
#

require 'rails_helper'

RSpec.describe SpectatorEntriesController, type: :controller do
  include_context 'login'

  let(:room) { create :room }

  describe 'POST #create' do
    subject { post :create, params: { room_id: room.id } }

    it 'create spectator with current_user and status is created' do
      expect { subject }.to change { SpectatorEntry.count }
      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: spectator_entry.id } }

    let!(:spectator_entry) { create :spectator_entry, room: room, user: user }

    context 'when permission accepted' do
      let(:user) { current_user }

      it 'delete spectator and status is success' do
        aggregate_failures do
          expect { subject }.to change { SpectatorEntry.count }.by(-1)
          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'when permission denied' do
      let(:user) { create :user }

      it 'do not delete spectator and status is unauthorized' do
        aggregate_failures do
          expect { subject }.not_to change { SpectatorEntry.count }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
