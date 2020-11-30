# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  user_id      :integer          not null
#  active       :boolean          default(FALSE), not null
#  expires_at   :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#

FactoryGirl.define do
  factory :user_session do
    active false
    association :user, factory: :user

    trait :activate do
      active true
    end
  end
end
