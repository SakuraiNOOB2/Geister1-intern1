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

RSpec.describe 'Users', type: :request do
  include_context 'request describer'

  let(:serialized_user) { UserSerializer.new(user).to_json }
  let(:user_json) do
    {
      'user_id' => Integer,
      'name' => String,
      'created_at' => String,
      'updated_at' => String
    }
  end

  describe 'GET /api/users/:id' do
    include_context 'login'

    context 'when exist user id given' do
      let(:id) { user.id }
      let(:user) { current_user }

      it 'should return serialized user' do
        subject
        expect(response.body).to eq serialized_user
        expect(response.body).to be_json_as(user_json)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when not exist user id given' do
      let(:id) { 'invalid_id' }
      let(:exception) { ApplicationController::RecordNotFound.new }

      it 'should return record not found error' do
        subject
        expect(response.body).to be_json_including(
          'id' => exception.id,
          'message' => String
        )
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST /api/users' do
    context 'when correct param given' do
      let(:params) { attributes_for(:user) }
      let(:user) { User.last }

      it 'should return created user' do
        subject
        expect(response.body).to eq serialized_user
        expect(response.body).to be_json_as(user_json)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when invalid param given' do
      let(:params) { Hash.new }
      let(:exception) { Rack::JsonSchema::RequestValidation::InvalidParameter.new }

      it 'should return invalid parameter error' do
        subject
        expect(response.body).to be_json_including(
          'id' => exception.id,
          'message' => String
        )
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
