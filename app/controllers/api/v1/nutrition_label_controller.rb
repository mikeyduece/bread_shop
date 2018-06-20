class Api::V1::NutritionLabelController < Api::V1::ApplicationController
  def show
    recipe = Recipe.find_by(name: params[:recipe_name])
    recipe.fetch_label_info
    render json: recipe.label
  end
end
