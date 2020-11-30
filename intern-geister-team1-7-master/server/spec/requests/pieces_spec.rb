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

RSpec.describe 'Pieces', type: :request do
  include_context 'request describer'
  include_context 'login'

  let(:piece_json) do
    {
      'piece_id' => Integer,
      'point_x' => Integer,
      'point_y' => Integer,
      'owner_user_id' => Integer,
      'captured' => Object,
      'kind' => String
    }
  end

  describe 'GET /api/games/:game_id/pieces' do
    before do
      create_list :piece, 8, game: game, owner_user: current_user
      create_list :piece, 8, game: game, owner_user: game.last_mover_user
      create :player_entry, user: current_user, room: game.room, index: 1
    end

    let(:game) { create :game, first_mover_user: current_user }
    let(:game_id) { game.id }
    let(:response_pieces) { JSON.parse(response.body)['pieces'] }
    let(:own_pieces) { response_pieces.select { |piece| piece['owner_user_id'] == current_user.id } }
    let(:other_pieces) { response_pieces.reject { |piece| piece['owner_user_id'] == current_user.id } }

    it 'should return serialized pieces' do
      subject
      expect(response.body).to be_json_as('pieces' => Array.new(16) { piece_json })
      expect(own_pieces.pluck('kind')).not_to include 'unknown'
      expect(other_pieces.pluck('kind')).to all(eq('unknown'))
    end
  end

  describe 'GET /api/pieces/:id' do
    let(:piece) { create :piece, owner_user: owner_user, game: game, captured: captured }
    let(:id) { piece.id }
    let(:captured) { false }

    let(:room) { create :room }
    let(:game) { create :game, room: room }
    let(:room) { create :room }
    let(:other_user) { create :user }

    let(:response_json) { JSON.parse(response.body) }

    shared_context 'current_user enter with player' do
      before do
        create(:player_entry, user: current_user, index: 1, room: room)
        create(:player_entry, user: other_user, index: 2, room: room)
      end
    end

    context 'when current_user is piece owner' do
      include_context 'current_user enter with player'

      let(:owner_user) { current_user }

      it 'should return serialized piece' do
        subject
        expect(response.body).to be_json_as(piece_json)
        expect(response_json['kind']).to eq piece.kind
      end
    end

    context 'when current_user is not piece owner' do
      include_context 'current_user enter with player'

      let(:owner_user) { other_user }

      it 'should return not unknown kind' do
        subject
        expect(response_json['kind']).to eq 'unknown'
      end
    end

    context 'when current_user is not piece owner, but piece is captured' do
      include_context 'current_user enter with player'

      let(:owner_user) { other_user }
      let(:captured) { true }

      it 'should return not unknown kind' do
        subject
        expect(response_json['kind']).to eq piece.kind
      end
    end

    context 'when current_user is spectator' do
      before { create(:spectator_entry, user: current_user, room: room) }

      let(:owner_user) { other_user }

      it 'should return not unknown kind' do
        subject
        expect(response_json['kind']).to eq piece.kind
      end
    end

    context 'when current_user not enter to room' do
      let(:owner_user) { other_user }

      it 'should return not unknown kind' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/pieces/:id' do
    before { create :player_entry, user: current_user, room: room }

    let(:piece) { create :piece, point_y: 1, point_x: 1, owner_user: current_user, game: game }
    let(:room) { create :room }
    let(:game) { create :game, room: room, first_mover_user: current_user, status: :playing }
    let(:id) { piece.id }
    let(:params) { { point_x: 1, point_y: 2 } }

    it 'should return serialized piece' do
      subject
      expect(response.body).to be_json_as(piece_json)

      json = PieceSerializer.new(Piece.find(piece.id), scope: current_user, scope_name: :current_user).to_json
      expect(response.body).to eq json
    end

    context 'when current_user move piece to goal' do
      let(:piece) { create :piece, point_x: 1, point_y: 6, owner_user: current_user, game: game, kind: :good }
      let(:params) { { point_x: 0, point_y: 6 } }

      it { expect { subject }.to change { Game.find(game.id).winner_user }.from(nil).to(current_user) }
    end
  end
end
