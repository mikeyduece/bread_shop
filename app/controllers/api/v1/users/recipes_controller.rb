class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: {status: 200, recipes: recipes}
  end

  def show
    recipe = current_user.recipes.find_by_name(params[:recipe_name])
    render json: {status: 200,
                  recipe: {
                        name: recipe.name,
                        ingredients: recipe.ingredient_list,
                        total_percentage: recipe.total_percentage
                           }
                  }
  end

  def create
    recipe = Recipe.create(user_id: current_user.id, name: params[:recipe][:name])
    ingredients = Ingredient.create_list(params[:recipe][:ingredients].keys)
    rec_ings    = RecipeIngredient.create_with_list(recipe.id, params[:recipe][:ingredients])

    render json: {status: 201, recipe: {name: recipe.name,
                                        ingredients: rec_ings,
                                        total_percentage: recipe.total_percentage
                                        }
                 }
  end
end
