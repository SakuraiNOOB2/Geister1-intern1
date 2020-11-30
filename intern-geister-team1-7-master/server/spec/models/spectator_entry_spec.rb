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

RSpec.describe SpectatorEntry, type: :model do
  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end

  describe 'validation' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:room_id) }

    context 'uniqueness of user_id scoped_to room_id' do
      subject { same_entry.valid? }

      before { create :spectator_entry, room: room, user: user }

      let(:room) { create :room }
      let(:user) { create :user }
      let(:same_entry) { build :spectator_entry, room: room, user: user }

      it { is_expected.to be_falsey }
    end
  end
end
