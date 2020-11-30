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

RSpec.describe UserSessionsController, type: :controller do
  before { request.headers['CONTENT_TYPE'] = 'application/json' }

  describe 'POST #create' do
    subject { post :create, params: params }

    let(:params) { { name: name, password: password } }
    let(:user) { create :user }

    context 'when valid parameter' do
      let(:name) { user.name }
      let(:password) { user.password }

      it { expect { subject }.to change { UserSession.count }.by(1) }
    end

    context 'when invalid password' do
      let(:name) { user.name }
      let(:password) { 'invalid password' }

      it { expect { subject }.not_to change { UserSession.count } }
    end

    context 'when invalid user_name' do
      let(:name) { 'invalid username' }
      let(:password) { 'invalid password' }

      it { expect { subject }.not_to change { UserSession.count } }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: user_session.id } }

    before { create :user_session }

    let(:user_session) { UserSession.first }

    context 'when valid parameter' do
      include_context 'login'

      it { expect { subject }.to change { UserSession.count }.by(-1) }
    end

    context 'when not login' do
      it { expect { subject }.not_to change { UserSession.count } }
    end
  end
end
