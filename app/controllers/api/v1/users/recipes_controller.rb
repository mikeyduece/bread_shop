# frozen_string_literal: true

class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :ingredient_list, only: [:create]
  before_action :tag_list, only: [:create], if: -> { params[:tags].present? }

  def index
    recipes = current_user.recipes
    render(json: recipes, status: 200)
  end

  def show
    recipe = current_user.recipes.find_by(name: params[:recipe_name])
    family = recipe.assign_family
    recipe.update(family: family)
    render(
      status: 200,
      json: {
        recipe: {
          id: recipe.id,
          name: recipe.name,
          ingredients: recipe.ingredient_list,
          total_percentage: recipe.total_percent,
          family: recipe.family
        }
      }
    )
  end

  def create
    recipe_name = params[:recipe][:name]
    recipe = Recipe.find_by(name: recipe_name)
    if !recipe
      recipe = Recipe.create(user_id: current_user.id, name: recipe_name)
      recipe_feed_and_family(recipe)
      render(
        status: 201,
        json: {
          recipe: {
            id: recipe.id,
            name: recipe.name,
            ingredients: recipe_ingredient_list(recipe),
            total_percentage: recipe.total_percent
          },
          tags: recipe.tags.pluck(:name)
        }
      )
    else
      render(status: 404, json: { message: 'You already have a recipe with that name' })
    end
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
    recipe.tags << tag_list if params[:tags].present?
    RecipeIngredient.create_with_list(recipe.id, params[:recipe][:ingredients])
  end

  def recipe_activity
    user = current_user.id
    client = Stream::Client.new(ENV['STREAM_KEY'], ENV['STREAM_SECRET'])
    feed = client.feed('user', user)
    activity_data = { actor: user, verb: 'post', object: 1, post: "#{current_user.name} created a new recipe" }
    feed.add_activity(activity_data)
  end

  def tag_list
    Tag.create_list(params[:tags])
  end

  def recipe_feed_and_family(recipe)
    recipe.update(family: recipe.assign_family)
    recipe_activity
  end
end
