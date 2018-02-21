class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: {status: 200, recipes: recipes}
  end
end
