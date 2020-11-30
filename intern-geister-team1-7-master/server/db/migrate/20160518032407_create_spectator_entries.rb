class CreateSpectatorEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :spectator_entries do |t|
      t.references :user, foreign_key: true, null: false
      t.references :room, foreign_key: true, null: false

      t.timestamps
    end

    add_index :spectator_entries, [:user_id, :room_id], unique: true
  end
end
