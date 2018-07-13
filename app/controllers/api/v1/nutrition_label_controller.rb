#frozen_string_literal: true

class Api::V1::NutritionLabelController < Api::V1::ApplicationController
  def show
    recipe = Recipe.find(params[:id])
    recipe.fetch_label_info
    render(json: recipe.label)
  end
end
