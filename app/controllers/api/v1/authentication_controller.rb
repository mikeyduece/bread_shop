class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def amazon
    user_info = params[:user_info]
    token = TokiToki.encode(user_info)
    User.from_auth(user_info)
    render(json: { status: 200, token: token })
  end
end
