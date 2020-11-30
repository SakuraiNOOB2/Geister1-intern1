# == Schema Information
#
# Table name: games
#
#  id                  :integer          not null, primary key
#  turn_count          :integer          default(0), not null
#  turn_mover_user_id  :integer          not null
#  first_mover_user_id :integer          not null
#  last_mover_user_id  :integer          not null
#  status              :integer          default("preparing"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lock_version        :integer          default(0), not null
#  winner_user_id      :integer
#
# Indexes
#
#  index_games_on_first_mover_user_id  (first_mover_user_id)
#  index_games_on_last_mover_user_id   (last_mover_user_id)
#  index_games_on_turn_mover_user_id   (turn_mover_user_id)
#  index_games_on_winner_user_id       (winner_user_id)
#

FactoryGirl.define do
  factory :game do
    status { Game.statuses.keys.sample }

    association :room, factory: :room
    association :turn_mover_user, factory: :user
    association :first_mover_user, factory: :user
    association :last_mover_user, factory: :user

    trait :wity_entry do
      after(:create) do |game|
        FactoryGirl.create :player_entry, index: 1, user: game.first_mover_user, room: game.room
        FactoryGirl.create :player_entry, index: 2, user: game.last_mover_user, room: game.room
      end
    end
  end
end
