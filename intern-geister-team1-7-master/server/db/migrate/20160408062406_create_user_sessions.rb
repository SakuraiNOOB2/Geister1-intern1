class CreateUserSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_sessions do |t|
      t.string :access_token, null: false
      t.references :user, foreign_key: true, null: false
      t.boolean :active, null: false, default: false
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
