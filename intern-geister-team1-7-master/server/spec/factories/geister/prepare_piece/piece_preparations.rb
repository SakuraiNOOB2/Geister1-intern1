FactoryGirl.define do
  factory :geister_piece_preparation, class: Geister::PreparePiece::PiecePreparation do
    point_x { (2..5).to_a.sample  }
    point_y { [1, 2, 5, 6].sample }
    kind    { Piece::KINDS.sample }
  end
end
