class RoomFactory
  def initialize(user)
    @user = user
  end

  def create!
    ActiveRecord::Base.transaction do
      room = Room.create!(status: :waiting)

      room.player_entries.create!(index: 1, user: @user)

      2.upto(Room::PLAYER_ENTRY_COUNT).each do |index|
        room.player_entries.create!(index: index)
      end

      room
    end
  end
end
