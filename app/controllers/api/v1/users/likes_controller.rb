# frozen_string_literal: true

class Api::V1::Users::LikesController < Api::V1::ApplicationController
  def create
    like = Like.create(user_id: current_user.id, recipe_id: params[:recipe_id], target_id: target.id)

    render(json: like, message: "Liked #{@recipe.name}")
  end

  def destroy
    like = Like.find_by(target_id: target.id)
    like.delete
    render(json: { status: 204, message: "You have unliked #{@recipe.name}" })
  end

  private

  def target
    @recipe = Recipe.find(params[:recipe_id])
    User.find(@recipe.user_id)
  end
end
