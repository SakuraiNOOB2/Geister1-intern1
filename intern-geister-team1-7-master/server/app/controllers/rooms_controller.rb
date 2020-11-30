# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  status     :integer          default("waiting"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_rooms_on_game_id  (game_id)
#

class RoomsController < ApplicationController
  before_action :set_room, only: [:show]
  before_action only: [:create] { check_authority!(:create, Room) }

  def index
    rooms = Room.where.not(status: :finished).includes(player_entries: [:user])

    render json: rooms, each_serializer: RoomSerializer, adapter: :json
  end

  def show
    render json: @room
  end

  def create
    room = RoomFactory.new(current_user).create!
    player_entry = PlayerEntry.find_by(room: room, user: current_user)

    render json: player_entry, status: :created
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end
