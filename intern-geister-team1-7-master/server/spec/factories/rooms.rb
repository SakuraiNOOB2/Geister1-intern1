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

FactoryGirl.define do
  factory :room do
    status { Room.statuses.keys.sample }

    trait :with_owner do
      after(:create) do |room|
        FactoryGirl.create(:player_entry, :with_user, index: 1, room: room)
        FactoryGirl.create(:player_entry, room: room, index: 2)
      end
    end

    trait :with_full_player_entries do
      after(:create) do |room|
        FactoryGirl.create(:game, room: room, status: :preparing)
        FactoryGirl.create(:player_entry, :with_user, index: 1, room: room)
        FactoryGirl.create(:player_entry, :with_user, index: 2, room: room)
      end
    end
  end
end
