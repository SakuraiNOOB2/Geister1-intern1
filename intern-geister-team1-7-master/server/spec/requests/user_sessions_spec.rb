# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  user_id      :integer          not null
#  active       :boolean          default(FALSE), not null
#  expires_at   :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe 'UserSessions', type: :request do
  include_context 'request describer'

  let(:serialized_resource) { UserSessionsSerializer.new(resource).to_json }
  let(:resource) { create :user_session }

  describe 'POST /api/user_sessions' do
    let(:params) { { name: user.name, password: user.password } }
    let(:user) { create :user }

    it 'should return access_token' do
      subject
      expect(response.body).to be_json_as(
        user_session_id: Integer,
        access_token: String,
        user_id: Integer
      )
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /api/user_sessions/:id' do
    include_context 'login'

    let(:id) { current_user.id }
    let(:serialized_user) { UserSerializer.new(current_user).to_json }

    it 'should return access_token' do
      subject
      expect(response.body).to eq serialized_user
      expect(response).to have_http_status(:success)
    end
  end
end
