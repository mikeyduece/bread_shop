# frozen_string_literal: true

class Api::V1::Users::LikesController < Api::V1::ApplicationController
  def create
    like = Like.create(user_id: current_user.id, recipe_id: params[:recipe_id])
    liked = current_user.likes << like
    render(status: 201, json: liked)
  end

  private

  def like_activity
    user = current_user.id
    client = Stream::Client.new(ENV['STREAM_KEY'], ENV['STREAM_SECRET'])
    feed = client.feed('user', user)
    activity_data = { actor: user, verb: 'post', object: 1, post: "#{current_user.name} liked a recipe" }
    feed.add_activity(activity_data)
  end
end
