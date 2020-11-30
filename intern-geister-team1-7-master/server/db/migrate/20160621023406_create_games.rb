class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :turn_count, default: 0, null: false
      t.integer :turn_mover_user_id, null: false
      t.integer :first_mover_user_id, null: false
      t.integer :last_mover_user_id, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :games, :turn_mover_user_id
    add_index :games, :first_mover_user_id
    add_index :games, :last_mover_user_id
  end
end
