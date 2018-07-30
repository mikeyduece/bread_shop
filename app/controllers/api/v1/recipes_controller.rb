# frozen_string_literal: true

class Api::V1::RecipesController < Api::V1::ApplicationController
  def index
    params[:per_page] ||= '10'
    recipes = Recipe.paginate(page: params[:page], per_page: params[:per_page])
    render(status: 200, json: recipes, each_serializer: Api::V1::RecipeSerializer)
  end

  def show
    recipe = Recipe.find(recipe_id_params)
    render(status: 200, json: recipe, serializer: Api::V1::RecipeSerializer)
  end

  private

  def recipe_id_params
    params.permit(:id)[:id]
  end
end
