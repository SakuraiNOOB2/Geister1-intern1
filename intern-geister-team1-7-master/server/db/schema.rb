# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160803053636) do

  create_table "games", force: :cascade do |t|
    t.integer  "turn_count",          default: 0, null: false
    t.integer  "turn_mover_user_id",              null: false
    t.integer  "first_mover_user_id",             null: false
    t.integer  "last_mover_user_id",              null: false
    t.integer  "status",              default: 0, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "lock_version",        default: 0, null: false
    t.integer  "winner_user_id"
    t.index ["first_mover_user_id"], name: "index_games_on_first_mover_user_id"
    t.index ["last_mover_user_id"], name: "index_games_on_last_mover_user_id"
    t.index ["turn_mover_user_id"], name: "index_games_on_turn_mover_user_id"
    t.index ["winner_user_id"], name: "index_games_on_winner_user_id"
  end

  create_table "pieces", force: :cascade do |t|
    t.integer  "point_x",                       null: false
    t.integer  "point_y",                       null: false
    t.integer  "owner_user_id",                 null: false
    t.boolean  "captured",      default: false, null: false
    t.integer  "kind",          default: 0,     null: false
    t.integer  "game_id",                       null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["game_id"], name: "index_pieces_on_game_id"
    t.index ["owner_user_id"], name: "index_pieces_on_owner_user_id"
  end

  create_table "player_entries", force: :cascade do |t|
    t.integer  "room_id",                  null: false
    t.integer  "user_id"
    t.integer  "index",                    null: false
    t.integer  "lock_version", default: 0, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["room_id", "user_id"], name: "index_player_entries_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_player_entries_on_room_id"
    t.index ["user_id"], name: "index_player_entries_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "game_id"
    t.index ["game_id"], name: "index_rooms_on_game_id"
  end

  create_table "spectator_entries", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "room_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_spectator_entries_on_room_id"
    t.index ["user_id", "room_id"], name: "index_spectator_entries_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_spectator_entries_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.string   "access_token",                 null: false
    t.integer  "user_id",                      null: false
    t.boolean  "active",       default: false, null: false
    t.datetime "expires_at",                   null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
