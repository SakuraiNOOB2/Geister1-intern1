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

class GamesController < ApplicationController
  before_action :set_game, only: [:show, :prepare]
  before_action only: [:show] { check_authority!(:show, Game) }

  def show
    render json: @game
  end

  def prepare
    @game.prepare_piece!(prepare_params)

    render json: piece_preparations, each_serializer: Geister::PiecePreparationSerializer, adapter: :json
  end

  private

  def piece_preparations
    json_params.permit(piece_preparations: [:kind, :point_x, :point_y]).to_h.symbolize_keys
  end

  def prepare_params
    piece_preparations.merge(user: current_user)
  end

  def set_game
    @game = Game.find(params[:id] || params[:game_id])
  end
end
