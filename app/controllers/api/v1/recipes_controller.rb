# frozen_string_literal: true

class Api::V1::RecipesController < Api::V1::ApplicationController
  def index
    recipes = Recipe.all
    render(status: 200, json: recipes, each_serializer: Api::V1::RecipeSerializer)
  end

  def show
    recipe = Recipe.find(params[:id])
    render(status: 200, json: recipe, serializer: Api::V1::RecipeSerializer)
  end
end
