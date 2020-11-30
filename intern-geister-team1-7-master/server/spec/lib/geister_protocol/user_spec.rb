require 'rails_helper'

describe GeisterProtocol::User, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'GET /api/users/:user_id' do
    let(:user_id) { 1 }
    let(:responses) { GeisterProtocol::User.example_hash(:user_id, :name, :created_at, :updated_at) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /api/users' do
    let(:params)    { GeisterProtocol::User.example_hash(:name, :password) }
    let(:responses) { GeisterProtocol::User.example_hash(:user_id, :name, :created_at, :updated_at) }

    it 'returns 201 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:created)
    end
  end
end
