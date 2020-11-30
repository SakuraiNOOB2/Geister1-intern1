# == Schema Information
#
# Table name: spectator_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  room_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spectator_entries_on_room_id              (room_id)
#  index_spectator_entries_on_user_id              (user_id)
#  index_spectator_entries_on_user_id_and_room_id  (user_id,room_id) UNIQUE
#

class SpectatorEntriesController < ApplicationController
  before_action :set_room, only: [:create]
  before_action only: [:create] { check_authority!(:create, PlayerEntry) }
  before_action :set_spectator_entry, only: [:destroy] { check_authority!(:destroy, @spectator_entry) }

  def create
    spectator_entry = @room.enter_as_spectator!(current_user)

    render json: spectator_entry, status: :created
  end

  def destroy
    user = @spectator_entry.user
    @spectator_entry.delete

    render json: user
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_spectator_entry
    @spectator_entry = SpectatorEntry.find(params[:id])
  end
end
