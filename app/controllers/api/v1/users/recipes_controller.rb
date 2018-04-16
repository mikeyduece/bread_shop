# frozen_string_literal: true

class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :ingredient_list, only: [:create]

  def index
    recipes = current_user.recipes
    render(json: recipes, status: 200)
  end

  def show
    recipe = current_user.recipes.find_by(name: params[:recipe_name])
    family = recipe.assign_family
    recipe.update(family: family)
    render(
      json: {
        status: 200,
        recipe: {
          name: recipe.name,
          ingredients: recipe.ingredient_list,
          total_percentage: recipe.total_percent,
          family: recipe.family
        }
      }
    )
  end

  def create
    recipe = Recipe.create(
      user_id: current_user.id,
      name: params[:recipe][:name]
    )
    recipe_ingredients = recipe_ingredient_list(recipe)
    recipe.update(family: recipe.assign_family)
    render(
      json: {
        status: 201,
        recipe: {
          name: recipe.name,
          ingredients: recipe_ingredients,
          total_percentage: recipe.total_percent
        }
      }
    )
  end

  def destroy
    recipe = current_user.recipes.find_by_name(params[:recipe_name])
    recipe.user.recipes.delete(recipe)
    recipe.destroy
    render(json: { status: 204, message: "Successfully deleted #{recipe.name}" })
  end

  private

  def ingredient_list
    Ingredient.create_list(params[:recipe][:ingredients].keys)
  end

  def recipe_ingredient_list(recipe)
    RecipeIngredient.create_with_list(recipe.id, params[:recipe][:ingredients])
  end
end
