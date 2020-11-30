shared_context 'piece_preparations' do
  let(:correct_first_piece_preparations) do
    [
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 2, point_y: 1),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 3, point_y: 1),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 4, point_y: 1),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 5, point_y: 1),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 2, point_y: 2),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 3, point_y: 2),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 4, point_y: 2),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 5, point_y: 2)
    ]
  end

  let(:correct_last_piece_preparations) do
    [
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 2, point_y: 5),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 3, point_y: 5),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 4, point_y: 5),
      attributes_for(:geister_piece_preparation, kind: 'good', point_x: 5, point_y: 5),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 2, point_y: 6),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 3, point_y: 6),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 4, point_y: 6),
      attributes_for(:geister_piece_preparation, kind: 'evil', point_x: 5, point_y: 6)
    ]
  end
end
