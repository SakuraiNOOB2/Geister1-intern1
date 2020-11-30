module Rescueable
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      render json: { id: :access_denied, message: exception.message }, status: :unauthorized
    end

    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { id: :record_not_found, message: exception.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordInvalid do |invalid|
      render json: { id: :validation_error, message: invalid.record.errors.messages.to_s }, status: :bad_request
    end

    rescue_from ActionController::BadRequest do |exception|
      render json: { id: :bad_request, message: exception.message }, status: :bad_request
    end

    rescue_from Errors::APIError do |exception|
      render json: { id: exception.id, message: exception.message }, status: exception.status
    end
  end
end
