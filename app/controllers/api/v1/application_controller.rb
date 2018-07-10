# frozen_string_literal: true

class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :authenticate_user!

  def current_user
    token = params[:token]
    if token.present?
      payload = TokiToki.decode(token)
      @current_user ||= User.find_by_email(payload[0]['sub']['email'])
    end
  end

  def authenticate_user!
    head(:unauthorized) unless logged_in?
  end

  def render_json_validation_error(resource)
    render json: resource, status: :bad_request, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end

  private

  def logged_in?
    current_user != nil
  end
end
