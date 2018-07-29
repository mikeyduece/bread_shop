#frozen_string_literal: true

class Api::V1::NutritionLabelController < Api::V1::ApplicationController
  def show
    recipe = Recipe.find(recipe_id_params)
    recipe.fetch_label_info
    render(json: recipe.label)
  end

  private

  def recipe_id_params
    params.permit(:id)[:id]
  end
end
