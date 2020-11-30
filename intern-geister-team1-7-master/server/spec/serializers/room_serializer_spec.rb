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

require 'rails_helper'

RSpec.describe RoomSerializer do
end
