# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_rooms_on_game_id  (game_id)
#

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  include_context 'login'

  describe 'GET #index' do
    it 'should have http_status success' do
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe 'GET #show' do
    let(:room) { create :room }

    it 'should have http_status success' do
      get :show, params: { id: room.id }
      expect(response).to have_http_status :success
    end
  end

  describe 'POST #create' do
    subject { post :create }

    it { expect { subject }.to change { Room.count }.by(1) }
    it { expect { subject }.to change { PlayerEntry.count }.by(2) }
  end
end
