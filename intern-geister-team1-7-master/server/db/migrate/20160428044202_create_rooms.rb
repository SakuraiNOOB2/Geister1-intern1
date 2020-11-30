class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
