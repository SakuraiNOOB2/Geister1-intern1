# == Schema Information
#
# Table name: spectator_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spectator_entries_on_room_id              (room_id)
#  index_spectator_entries_on_user_id              (user_id)
#  index_spectator_entries_on_user_id_and_room_id  (user_id,room_id) UNIQUE
#

require 'rails_helper'

RSpec.describe 'SpectatorEntries', type: :request do
  include_context 'request describer'
  include_context 'login'

  let(:room) { create :room }

  let(:spectator_entry_json) do
    {
      'spectator_entry_id' => Integer,
      'room_id' => Integer,
      'user_id' => Integer,
      'created_at' => String,
      'updated_at' => String
    }
  end

  let(:user_json) do
    {
      'user_id' => Integer,
      'name' => String,
      'created_at' => String,
      'updated_at' => String
    }
  end

  describe 'POST /api/rooms/:room_id/spectator_entries' do
    let(:room_id) { room.id }
    let(:spectator_entry) { SpectatorEntry.last }
    let(:serialized_spectator) { SpectatorEntrySerializer.new(spectator_entry).to_json }

    it 'should returns serialized_spectator' do
      subject
      expect(response.body).to eq serialized_spectator
      expect(response.body).to be_json_as(spectator_entry_json)
    end
  end

  describe 'DELETE /api/spectator_entries/:id' do
    let(:id) { spectator_entry.id }
    let(:spectator_entry) { create :spectator_entry, room: room, user: current_user }
    let(:serialized_user) { UserSerializer.new(current_user).to_json }

    it 'should returns serialized_user' do
      subject
      expect(response.body).to eq serialized_user
      expect(response.body).to be_json_as(user_json)
    end
  end
end
