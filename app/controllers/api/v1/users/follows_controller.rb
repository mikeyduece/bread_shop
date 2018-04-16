class Api::V1::Users::FollowsController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :target_email_param

  def create
    # target = User.find_by(email: params[:target_email])
    follow = Follow.new(target_id: @target.id, user_id: current_user.id)
    follow.user = current_user
    if follow.save
      StreamRails.feed_manager.follow_user(follow.user_id, follow.target_id)
    end

    render(json: 'Followed!', status: 200)
  end

  def destroy
    # target = User.find_by(email: params[:target_email])
    follow = Follow.find_by(target_id: @target.id)
    if follow.user_id == current_user.id
      follow.destroy!
      StreamRails.feed_manager.unfollow_user(follow.user_id, follow.target_id)
    end

    render(json: 'Unfollowed!', status: 204)
  end

  private

  def target_email_param
    @target = User.find_by(email: params[:target_email])
  end
end
