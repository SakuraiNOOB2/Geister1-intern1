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

class PiecesController < ApplicationController
  before_action :set_game, only: [:index]
  before_action :set_piece, only: [:show, :update]

  # see: https://github.com/rails-api/active_model_serializers/blob/v0.10.2/docs/general/serializers.md#scope
  serialization_scope :current_user

  def index
    raise CanCan::AccessDenied unless @game.entry?(current_user)

    pieces = Piece.where(game: @game).includes(game: [:room])

    render json: pieces, adapter: :json
  end

  def show
    raise CanCan::AccessDenied unless @piece.game.entry?(current_user)

    render json: @piece
  end

  def update
    Geister.move_piece!(
      piece: @piece,
      user: current_user,
      point_y: piece_params[:point_y],
      point_x: piece_params[:point_x]
    )

    render json: @piece
  end

  private

  def piece_params
    params.permit(:point_y, :point_x).to_h.merge(user: current_user).symbolize_keys
  end

  def set_piece
    @piece = Piece.find(params[:id])
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
