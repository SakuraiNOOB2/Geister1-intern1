require 'rails_helper'

describe GeisterProtocol::Room, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  let(:room_response) do
    GeisterProtocol::Room.example_hash(
      :room_id, :status, :owner_name,
      :game_id, :created_at, :updated_at
    )
  end

  describe 'GET /api/rooms' do
    let(:responses) { GeisterProtocol::Room.example_hash(:rooms) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/rooms/:room_id' do
    let(:room_id) { 1 }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(room_response)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/rooms' do
    it 'returns 201 and correct response' do
      subject
      expect(response.body).to be_json_as(
        'player_entry_id' => Integer,
        'room_id' => Integer,
        'user_id' => Integer
      )
      expect(response).to have_http_status(:created)
    end
  end

  describe 'GET /api/rooms' do
    let(:responses) { GeisterProtocol::Room.example_hash(:rooms) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end
end
