# frozen_string_literal: true

class Api::V1::Users::UsersController < Api::V1::ApplicationController
  def index
    users = User.all
    render( status: 200, json: users, each_serializer: Api::V1::UserSerializer)
  end
end
