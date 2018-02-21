class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: {status: 200, recipes: recipes}
  end

  def show
    recipe = current_user.recipes.find_by_name(params[:recipe_name])
    render json: {status: 200,
                  recipe.name => {
                        ingredients: recipe.ingredient_list,
                        total_percentage: recipe.total_percentage
                                   }
                 }
  end
end
