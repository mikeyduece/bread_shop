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

  def create
    recipe = Recipe.new(user_id: current_user.id, name: params[:recipe][:name])
    ingredients = Ingredient.create_list(params[:recipe][:ingredients].keys)
    # ingredients = Ingredient.new()
    # if recipe.save!
    #   current_user.recipes << recipe
    #   render json: {status: 201 }
    # end
    require 'pry'; binding.pry
  end
end
