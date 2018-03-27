class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    recipes = current_user.recipes
    render json: { status: 200, recipes: recipes }
  end

  def show
    recipe = current_user.recipes.find_by(name: params[:recipe_name])
    if recipe.family.nil?
      recipe.update(family: recipe.assign_family)
    end

    render json: {
      status: 200,
      recipe: {
        name: recipe.name,
        ingredients: recipe.ingredient_list,
        total_percentage: recipe.total_percentage,
        family: recipe.family
      }
    }
  end

  def create
    recipe = Recipe.create(user_id: current_user.id, name: params[:recipe][:name])
    Ingredient.create_list(params[:recipe][:ingredients].keys)
    rec_ings = RecipeIngredient.create_with_list(recipe.id, params[:recipe][:ingredients])
    recipe.update(family: recipe.assign_family)

    render json: {
      status: 201, recipe: {
        name: recipe.name,
        ingredients: rec_ings,
        total_percentage: recipe.total_percentage
      }
    }
  end

  def destroy
    recipe = current_user.recipes.find_by_name(params[:recipe_name])
    current_user.user_recipes.find_by(recipe_id: recipe.id).destroy
    recipe.recipe_ingredients.delete_all
    recipe.destroy
    render json: { status: 204, message: "Successfully deleted #{recipe.name}" }
  end
end
