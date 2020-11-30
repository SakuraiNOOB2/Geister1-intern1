# == Schema Information
#
# Table name: pieces
#
#  id            :integer          not null, primary key
#  point_x       :integer          not null
#  point_y       :integer          not null
#  owner_user_id :integer          not null
#  captured      :boolean          default(FALSE), not null
#  kind          :integer          default("good"), not null
#  game_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_pieces_on_game_id        (game_id)
#  index_pieces_on_owner_user_id  (owner_user_id)
#

require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  include_context 'login'

  describe '#GET #index' do
    before { create :player_entry, room: room, user: current_user, index: 1 }

    let(:room) { create :room }
    let(:game) { create :game, room: room }

    it 'returns http success' do
      get :index, params: { game_id: game.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    before { create :player_entry, room: piece.game.room, user: current_user, index: 1 }

    let(:room) { create :room }
    let(:game) { create :game, room: room }
    let(:piece) { create :piece, game: game, point_x: 1, point_y: 1 }

    it 'returns http success' do
      get :show, params: { id: piece.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    subject { put :update, params: { id: piece.id, point_x: point_x, point_y: point_y } }

    before { create :player_entry, user: current_user, room: game.room }

    let(:piece) { create :piece, point_x: 1, point_y: 1, owner_user: current_user, game: game }
    let(:game) { create :game, first_mover_user: current_user, status: :playing }
    let(:verify_target) { proc { [Piece.find(piece.id).point_x, Piece.find(piece.id).point_y] } }
    let(:point_x) { 1 }
    let(:point_y) { 2 }

    it 'returns http success' do
      expect { subject }.to change { verify_target.call }.from([1, 1]).to([1, 2])
      expect(response).to have_http_status(:success)
    end
  end
end
