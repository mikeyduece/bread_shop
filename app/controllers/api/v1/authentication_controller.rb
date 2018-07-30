# frozen_string_literal: true

class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def amazon
    token = TokiToki.encode(user_params)
    user = User.from_auth(user_params)
    render(status: 200, json: { user: user, token: token, serializer: Api::V1::UserSerializer })
  end

  private

  def user_params
    params.require(:user_info)
      .permit(:provider, :uid, info: %i[email name postal_code],
        credentials: %i[token])
      .to_h
      .deep_symbolize_keys
  end
end
