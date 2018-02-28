class Api::V1::ApplicationController < ActionController::Base
  helper_method :current_user, :authenticate_user!

  def current_user
    if params[:token].present?
      token = params[:token]
      payload = TokiToki.decode(token)
      @current_user ||= User.find_by_email(payload[0]['sub']['email'])
    end
  end

  def logged_in?
    current_user != nil
  end

  def authenticate_user!
    head :unauthorized unless logged_in?
  end
end