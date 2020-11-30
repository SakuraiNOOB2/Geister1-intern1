class AddColumnWinnerUserToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :winner_user_id, :integer
    add_index :games, :winner_user_id
  end
end
