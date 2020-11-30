# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before { request.headers['CONTENT_TYPE'] = 'application/json' }

  describe 'POST #create' do
    subject { post :create, params: params }

    context 'when correct param given' do
      let(:params) { { name: 'alice', password: 'password1234' } }

      it { expect { subject }.to change { User.count }.by(1) }
    end

    context 'when invalid param given' do
      let(:params) { { name: '', password: '' } }

      it { expect { subject }.not_to change { User.count } }
    end
  end
end
