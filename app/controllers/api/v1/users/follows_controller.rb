# frozen_string_literal: true

class Api::V1::Users::FollowsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def create
    target = User.find(params[:target_id])
    follow = Follow.new(target_id: target.id, user_id: current_user.id)
    follow.user = current_user
    StreamRails.feed_manager.follow_user(follow.user_id, follow.target_id) if follow.save

    render(json: 'Followed!', status: 200)
  end

  def destroy
    target = User.find(params[:target_id])
    follow = Follow.find_by(target_id: target.id)
    if follow.user_id == current_user.id
      follow.destroy!
      StreamRails.feed_manager.unfollow_user(follow.user_id, follow.target_id)
    end

    render(json: 'Unfollowed!', status: 204)
  end
end
