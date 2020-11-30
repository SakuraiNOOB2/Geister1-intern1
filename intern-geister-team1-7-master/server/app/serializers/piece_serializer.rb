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

class PieceSerializer < ActiveModel::Serializer
  attributes :piece_id, :point_x, :point_y, :owner_user_id, :captured, :kind

  alias piece object

  def piece_id
    piece.id
  end

  def kind
    authorize_to_access_piece_kind? ? piece.kind : 'unknown'
  end

  private

  def authorize_to_access_piece_kind?
    user_is_piece_owner? || user_is_spectator? || piece.captured?
  end

  def user_is_spectator?
    piece.game.enter_as_spectator?(current_user)
  end

  def user_is_piece_owner?
    current_user.id == piece.owner_user_id
  end
end
