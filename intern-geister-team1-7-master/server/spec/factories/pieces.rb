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

FactoryGirl.define do
  factory :piece do
    point_x  { (1..6).to_a.sample }
    point_y  { (1..6).to_a.sample }
    captured { false }
    kind     { Piece.kinds.keys.sample }

    association :owner_user, factory: :user
    association :game
  end
end
