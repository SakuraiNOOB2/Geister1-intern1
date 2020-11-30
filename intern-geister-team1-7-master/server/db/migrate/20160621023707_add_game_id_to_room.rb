class AddGameIdToRoom < ActiveRecord::Migration[5.0]
  def change
    add_reference :rooms, :game, foreign_key: true
  end
end
