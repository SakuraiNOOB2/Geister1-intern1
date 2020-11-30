FactoryGirl.define do
  factory :geister_prepare_piece_executor, class: Geister::PreparePiece do
    piece_preparations { Array.new(8) { build :geister_piece_preparation } }
    game { create :game }
    user { game.first_mover_user }
  end
end
