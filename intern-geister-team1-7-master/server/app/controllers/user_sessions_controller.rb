# == Schema Information
#
# Table name: user_sessions
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  user_id      :integer          not null
#  active       :boolean          default(FALSE), not null
#  expires_at   :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#

class UserSessionsController < ApplicationController
  skip_before_action :authenticate!, only: [:create]
  before_action only: [:destroy] { check_authority!(:destroy, current_session) }

  def create
    user = User.login(user_params)

    if user
      user_session = UserSession.create(user: user)
      render json: user_session, status: :created
    else
      render_error RecordNotFound.new(user)
    end
  end

  def destroy
    user = current_session.user
    current_session.delete
    render json: user
  end

  private

  def user_params
    json_params.permit(:name, :password)
  end
end
