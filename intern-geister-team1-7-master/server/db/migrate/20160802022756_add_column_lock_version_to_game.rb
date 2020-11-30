class AddColumnLockVersionToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :lock_version, :integer, null: false, default: 0
  end
end
