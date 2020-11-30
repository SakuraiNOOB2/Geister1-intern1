require 'rails_helper'

describe GeisterProtocol::PlayerEntry, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'POST /api/rooms/:room_id/player_entries' do
    let(:room_id) { 1 }
    let(:responses) { GeisterProtocol::PlayerEntry.example_hash(:player_entry_id, :room_id, :user_id) }

    it 'returns 201 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE /api/player_entries/:player_entry_id' do
    let(:player_entry_id) { 1 }
    let(:responses) { GeisterProtocol::PlayerEntry.example_hash(:player_entry_id, :room_id, :user_id) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end
end
