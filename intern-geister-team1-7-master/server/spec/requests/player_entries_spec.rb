# == Schema Information
#
# Table name: player_entries
#
#  id           :integer          not null, primary key
#  room_id      :integer          not null
#  user_id      :integer
#  index        :integer          not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_player_entries_on_room_id              (room_id)
#  index_player_entries_on_room_id_and_user_id  (room_id,user_id) UNIQUE
#  index_player_entries_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe 'PlayerEntries', type: :request do
  include_context 'request describer'
  include_context 'login'

  let(:other_user) { create :user }
  let(:player_entry_json) do
    {
      'player_entry_id' => Integer,
      'room_id' => Integer,
      'user_id' => ->(v) { v.is_a?(NilClass) || v.is_a?(Integer) }
    }
  end

  describe 'POST /api/rooms/:room_id/player_entries' do
    let(:room_id) { room.id }
    let(:room) { RoomFactory.new(other_user).create! }
    let(:player_entry) { room.player_entries.find_by!(index: 2) }
    let(:serialized_player) { PlayerEntrySerializer.new(player_entry).to_json }

    it 'should return serialized player entry' do
      subject
      expect(response.body).to eq serialized_player
      expect(response.body).to be_json_as(player_entry_json)
    end
  end

  describe 'DELETE /api/player_entries/:id' do
    before do
      player_entry.user = current_user
      player_entry.save
    end

    let(:id) { player_entry.id }
    let(:room) { RoomFactory.new(current_user).create! }
    let(:player_entry) { room.player_entries.find_by!(index: 1) }
    let(:after_player_entry) { PlayerEntry.find(player_entry.id) }
    let(:serialized_player) { PlayerEntrySerializer.new(after_player_entry).to_json }

    it 'should return serialized player entry' do
      subject
      expect(response.body).to eq serialized_player
      expect(after_player_entry.user).to be_nil
      expect(response.body).to be_json_as(player_entry_json)
    end
  end
end
