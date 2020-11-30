# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#

class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  skip_before_action :authenticate!, only: [:create]

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)
    user.save!

    render json: user, status: :created
  end

  private

  def user_params
    json_params.permit(:name, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
