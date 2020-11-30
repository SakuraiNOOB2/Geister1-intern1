class ApplicationController < ActionController::API
  before_action :authenticate!

  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::Serialization
  include CanCan::ControllerAdditions
  include Errors
  include Rescueable

  def render_error(exception)
    render(
      json: { id: exception.id, message: exception.message },
      status: exception.status
    )
  end

  def current_user
    @current_user ||= current_session.try(:user)
  end

  def json_params
    @json_params ||= begin
      json = JSON.parse(request.body.read, symbolized_names: true)
      request.body.rewind if request.body.respond_to?(:rewind)
      ActionController::Parameters.new(json)
    rescue JSON::ParserError
      ActionController::Parameters.new {}
    end
  end

  def check_authority!(action, resource)
    raise CanCan::AccessDenied.new, 'Permission denied' unless can? action, resource
  end

  def current_session
    @current_session ||= authenticate_with_http_token { |token| UserSession.find_by(access_token: token) }
  end

  def authenticate!
    return render_error UnAuthorizedError.new unless current_session
    return render_error SessionExpiredError.new if current_session.expired?

    current_session.update_expiration!
  end
end
