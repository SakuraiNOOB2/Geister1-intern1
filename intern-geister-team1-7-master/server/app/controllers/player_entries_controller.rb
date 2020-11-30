# == Schema Information
#
# Table name: player_entries
#
#  id           :integer          not null, primary key
#  room_id      :integer          not null
#  user_id      :integer
#  index        :integer          not null
#  lock_version :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_player_entries_on_room_id              (room_id)
#  index_player_entries_on_room_id_and_user_id  (room_id,user_id) UNIQUE
#  index_player_entries_on_user_id              (user_id)
#

class PlayerEntriesController < ApplicationController
  before_action :set_room, only: [:create]
  before_action only: [:create] { check_authority!(:create, PlayerEntry) }
  before_action :set_player_entry, only: [:destroy] { check_authority!(:destroy, @player_entry) }

  def create
    player_entry = @room.enter_as_player!(current_user)

    GameStarter.new(@room).start! if @room.ready?

    render json: player_entry, status: :created
  rescue ActiveRecord::StaleObjectError, Errors::FullHouseError
    render_error FullHouseError.new("room#{params[:id]} was full house")
  end

  def destroy
    Geister.leave_room!(player_entry: @player_entry)

    render json: @player_entry
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_player_entry
    @player_entry = PlayerEntry.find(params[:id])
  end
end
