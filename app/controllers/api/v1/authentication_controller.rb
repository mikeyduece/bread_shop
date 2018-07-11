# frozen_string_literal: true

class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def amazon
    user_info = params[:user_info]
    token = TokiToki.encode(user_info)
    user = User.from_auth(user_info)
    render(status: 200, json: { user: user, token: token, serializer: Api::V1::UserSerializer })
  end
end
