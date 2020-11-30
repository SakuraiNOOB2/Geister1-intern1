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

class UserSession < ApplicationRecord
  AVAILABLE_TIME = 1.hour

  has_secure_token :access_token

  belongs_to :user

  before_create :activate, :set_expiration

  validates :user_id, presence: true
  validates :active, inclusion: { in: [true, false] }

  def activate
    self.active = true
  end

  def activate!
    activate
    save!
  end

  def inactivate
    self.active = false
  end

  def inactivate!
    inactivate
    save!
  end

  def expired?
    Time.current > expires_at
  end

  def set_expiration
    self.expires_at = Time.current + AVAILABLE_TIME
  end

  def set_expiration!
    set_expiration
    save!
  end
  alias update_expiration! set_expiration!
end
