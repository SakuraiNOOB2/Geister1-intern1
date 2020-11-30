shared_context 'login' do
  let(:current_session) { create :user_session, user: current_user }
  let(:current_user) { create :user }
  let(:credentials) { ActionController::HttpAuthentication::Token.encode_credentials(current_session.access_token) }

  # for request spec with request describer
  let(:headers) { { 'HTTP_AUTHORIZATION' => credentials, 'Content-type' => 'application/json' } }

  # for controller spec
  before do
    request&.env.try(:[]=, 'HTTP_AUTHORIZATION', credentials)
  end
end
