class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.integer :point_x, null: false
      t.integer :point_y, null: false
      t.integer :owner_user_id, null: false
      t.boolean :captured, null: false, default: false
      t.integer :kind, null: false, default: 0
      t.references :game, null: false

      t.timestamps
    end

    add_index :pieces, :owner_user_id
  end
end
