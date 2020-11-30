# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_rooms_on_game_id  (game_id)
#

require 'rails_helper'

RSpec.describe 'Rooms', type: :request do
  include_context 'request describer'
  include_context 'login'

  let(:room_json) do
    {
      'room_id' => Integer,
      'status' => String,
      'owner_name' => String,
      'created_at' => String,
      'updated_at' => String,
      'game_id' => ->(v) { v.is_a?(NilClass) || v.is_a?(Integer) }
    }
  end

  describe 'GET /api/rooms' do
    before do
      create_list :room, 3, :with_owner, status: :waiting
      create_list :room, 3, :with_full_player_entries, status: :playing
      create_list :room, 3, :with_full_player_entries, status: :finished
    end

    let(:owner_names) { Room.where.not(status: :finished).includes(:player_entries).map(&:owner_name) }
    let(:response_json) { JSON.parse(response.body) }

    it 'should return serialized rooms' do
      subject
      expect(response.body).to be_json_as('rooms' => Array.new(6) { room_json })
      expect(response_json['rooms'].pluck('status')).not_to include 'finished'
      expect(response_json['rooms'].pluck('owner_name')).to match_array owner_names
    end
  end

  describe 'GET /api/rooms/:id' do
    let(:id) { room.id }
    let(:serialized_resource) { RoomSerializer.new(room).to_json }
    let(:room) { create :room, :with_owner, game: game }
    let(:response_game_id) { JSON.parse(response.body)['game_id'] }
    let(:game) { create :game }

    it 'should return serialized room' do
      subject
      expect(response.body).to eq serialized_resource
      expect(response.body).to be_json_as room_json
      expect(response_game_id).to eq game.id
    end
  end

  describe 'POST /api/rooms' do
    let(:serialized_resource) { PlayerEntrySerializer.new(player_entry).to_json }
    let(:player_entry) { PlayerEntry.find_by(room: room, user: current_user) }
    let(:room) { Room.last }

    it 'should return serialized room' do
      subject
      expect(response.body).to eq serialized_resource
      expect(response.body).to be_json_as(
        'player_entry_id' => Integer,
        'room_id' => Integer,
        'user_id' => Integer
      )
    end
  end
end
