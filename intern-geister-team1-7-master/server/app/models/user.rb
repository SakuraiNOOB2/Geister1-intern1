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

class User < ApplicationRecord
  has_secure_password

  has_one :player_entry
  has_one :spectator_entry

  has_many :user_sessions

  with_options json_schema: { resource: 'user' } do
    validates :name, presence: true, uniqueness: true
    validates :password, presence: true
  end

  validates :player_entry, absence: true, if: -> { spectator_entry.present? }
  validates :spectator_entry, absence: true, if: -> { player_entry.present? }

  def entered?
    player_entry.present? || spectator_entry.present?
  end

  class << self
    def login(params)
      user = User.find_by(name: params[:name])
      return nil unless user
      return nil unless user.authenticate(params[:password])

      user
    end
  end
end
