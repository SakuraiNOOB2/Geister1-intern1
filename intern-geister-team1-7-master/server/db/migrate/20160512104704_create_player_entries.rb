class CreatePlayerEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :player_entries do |t|
      t.references :room, null: false
      t.references :user
      t.integer :index, null: false
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :player_entries, [:room_id, :user_id], unique: true
  end
end
