class GameStarter
  def initialize(room)
    @room = room
  end

  def start!
    player_entries = @room.player_entries.shuffle

    game = Game.create!(
      first_mover_user: player_entries.first.user,
      last_mover_user: player_entries.last.user,
      status: :preparing
    )

    @room.status = 'playing'
    @room.game = game
    @room.save!
  end
end
