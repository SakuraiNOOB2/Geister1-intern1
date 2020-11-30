require 'rails_helper'

describe GeisterProtocol::SpectatorEntry, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'POST /api/rooms/:room_id/spectator_entries' do
    let(:room_id) { 1 }
    let(:responses) { GeisterProtocol::SpectatorEntry.example_hash(:spectator_entry_id) }

    it 'returns 201 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /api/spectator_entries/:spectator_entry_id' do
    let(:spectator_entry_id) { 1 }
    let(:responses) { GeisterProtocol::SpectatorEntry.example_hash(:spectator_entry_id) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end
end
