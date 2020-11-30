require 'rails_helper'

describe GeisterProtocol::Game, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'GET /api/games/:game_id' do
    let(:game_id) { 1 }
    let(:responses) do
      GeisterProtocol::Game.example_hash(
        :game_id, :turn_mover_user_id, :turn_count, :winner_user_id,
        :first_mover_user_id, :last_mover_user_id, :status
      )
    end

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/games/:game_id/preparation' do
    let(:game_id) { 1 }
    let(:params) { GeisterProtocol::Game.example_hash(:piece_preparations) }
    let(:responses) { GeisterProtocol::Game.example_hash(:piece_preparations) }

    it 'returns 201 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:created)
    end
  end
end
