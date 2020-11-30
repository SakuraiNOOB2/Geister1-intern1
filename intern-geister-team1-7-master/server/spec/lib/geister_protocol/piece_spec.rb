require 'rails_helper'

describe GeisterProtocol::Piece, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'GET /api/games/:game_id/pieces' do
    let(:game_id) { 1 }
    let(:responses) { GeisterProtocol::Piece.example_hash(:pieces) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/pieces/:piece_id' do
    let(:piece_id) { 1 }
    let(:responses) do
      GeisterProtocol::Piece.example_hash(:piece_id, :point_x, :point_y, :owner_user_id, :captured, :kind)
    end

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT /api/pieces/:piece_id' do
    let(:piece_id) { 1 }
    let(:params) { GeisterProtocol::Piece.example_hash(:point_x, :point_y) }
    let(:responses) do
      GeisterProtocol::Piece.example_hash(:piece_id, :point_x, :point_y, :owner_user_id, :captured, :kind)
    end

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end
end
