# frozen_string_literal: true
# :reek:MissingSafeMethod { exclude: [ authenticate_user! ] }

class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :authenticate_user!

  def current_user
    token = params[:token]
    if token.present?
      payload = TokiToki.decode(token)
      @current_user ||= User.find(payload[0]['sub']['id'])
    end
  end

  def authenticate_user!
    head(:unauthorized) unless logged_in?
  end

  private

  def logged_in?
    current_user != nil
  end
end
