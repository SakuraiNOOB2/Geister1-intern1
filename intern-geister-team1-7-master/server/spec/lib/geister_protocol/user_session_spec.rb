require 'rails_helper'

describe GeisterProtocol::UserSession, type: :request do
  include_context 'rack mock'
  include_context 'request describer'

  describe 'POST /api/user_sessions' do
    let(:params)    { GeisterProtocol::User.example_hash(:name, :password) }
    let(:responses) { GeisterProtocol::UserSession.example_hash(:user_session_id, :access_token, :user_id) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /api/user_sessions/:user_session_id' do
    let(:user_session_id) { 1 }
    let(:responses) { GeisterProtocol::User.example_hash(:user_id, :name, :created_at, :updated_at) }

    it 'returns 200 and correct response' do
      subject
      expect(response.body).to be_json_as(responses)
      expect(response).to have_http_status(:success)
    end
  end
end
