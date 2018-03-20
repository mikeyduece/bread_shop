class Api::V1::FamiliesController < Api::V1::ApplicationController

  def index
    families = Recipe.family_group
    render json: families
  end

  def show
    recipe = Recipe.where(family: params[:family_name])
    render json: recipe, each_serializer: Api::V1::RecipeSerializer
  end
end
