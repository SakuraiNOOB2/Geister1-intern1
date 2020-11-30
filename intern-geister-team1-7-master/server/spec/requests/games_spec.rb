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

RSpec.describe 'Games', type: :request do
  include_context 'request describer'
  include_context 'login'

  describe 'GET /api/games/:id' do
    let(:game) { create :game }
    let(:id) { game.id }
    let(:serialized_game) { GameSerializer.new(game).to_json }

    it 'should return serialized game' do
      subject
      expect(response.body).to eq serialized_game
      expect(response.body).to be_json_as(
        'game_id' => Integer,
        'turn_mover_user_id' => Integer,
        'turn_count' => Integer,
        'first_mover_user_id' => Integer,
        'last_mover_user_id' => Integer,
        'winner_user_id' => ->(v) { v.is_a?(NilClass) || v.is_a?(Integer) },
        'status' => String
      )
    end
  end

  describe 'POST /api/games/:game_id/preparation' do
    include_context 'piece_preparations'

    let(:game) { create :game, first_mover_user: current_user, status: :preparing }
    let(:game_id) { game.id }
    let(:params) { { piece_preparations: correct_first_piece_preparations } }

    let(:piece_preparation_json) do
      {
        'point_y' => Integer,
        'point_x' => Integer,
        'kind' => String
      }
    end

    it 'should return serialized piece_preparations' do
      subject
      expect(response.body).to be_json_as('piece_preparations' => Array.new(8) { piece_preparation_json })
    end
  end
end
