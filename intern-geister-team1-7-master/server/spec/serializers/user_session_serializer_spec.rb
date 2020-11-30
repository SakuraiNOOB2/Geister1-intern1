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

require 'rails_helper'

RSpec.describe UserSessionSerializer do
end
