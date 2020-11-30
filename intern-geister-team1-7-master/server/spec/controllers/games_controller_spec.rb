# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  turn_count          :integer          default(0), not null
#  turn_mover_user_id  :integer          not null
#  first_mover_user_id :integer          not null
#  last_mover_user_id  :integer          not null
#  status              :integer          default("preparing"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lock_version        :integer          default(0), not null
#  winner_user_id      :integer
#
# Indexes
#
#  index_games_on_first_mover_user_id  (first_mover_user_id)
#  index_games_on_last_mover_user_id   (last_mover_user_id)
#  index_games_on_turn_mover_user_id   (turn_mover_user_id)
#  index_games_on_winner_user_id       (winner_user_id)
#

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  include_context 'login'

  describe 'GET #show' do
    let(:game) { create :game }

    it 'returns http success' do
      get :show, params: { id: game.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #prepare' do
    subject { post :prepare, params: { game_id: game.id, piece_preparations: correct_first_piece_preparations } }

    before { request.headers['CONTENT_TYPE'] = 'application/json' }

    include_context 'piece_preparations'

    context 'when valid request' do
      let(:game) { create :game, first_mover_user: current_user, status: :preparing }

      it 'returns http success' do
        expect { subject }.to change { Piece.count }.from(0).to(8)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when game is not preparing' do
      let(:game) { create :game, first_mover_user: current_user, status: :playing }

      it 'returns http success' do
        expect { subject }.not_to change { Piece.count }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
