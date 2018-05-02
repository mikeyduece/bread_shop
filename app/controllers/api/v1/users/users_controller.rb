# frozen_string_literal: true

class Api::V1::Users::UsersController < Api::V1::ApplicationController
  def index
    users = User.all
    render(json: users, status: 200)
  end
end
