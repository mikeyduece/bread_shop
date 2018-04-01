class Api::V1::RecipesController < Api::V1::ApplicationController
  def show
    recipe = Recipe.new_totals(params[:recipe], params[:new_dough_weight])
    render json: recipe
  end
end
