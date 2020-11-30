# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#

FactoryGirl.define do
  factory :user do
    name       { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample(7).join }
    password   { [*'a'..'z', *'A'..'Z', *'0'..'9'].sample(8).join }
    created_at { Time.now - 1.week }
    updated_at { Time.now }
  end
end
