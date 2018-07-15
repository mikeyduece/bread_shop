# frozen_string_literal: true

class Api::V1::Users::RecipesController < Api::V1::ApplicationController
  before_action :authenticate_user!
  before_action :ingredient_list, only: %i[create]
  after_action :tag_list, only: %i[create], if: -> { params[:tags].present? }
  after_action :recipe_activity, only: %i[create]

  def index
    recipes = current_user.recipes
    render(json: recipes, status: 200, each_serializer: Api::V1::RecipeSerializer)
  end

  def show
    recipe = current_user.recipes.find(params[:recipe_id])
    render(
      status: 200,
      json: Api::V1::RecipeSerializer.new(recipe).attributes
    )
  end

  def create
    recipe_name = params[:recipe][:name]
    recipe = Recipe.find_by(name: recipe_name)
    if !recipe
      @recipe = Recipe.create(user_id: current_user.id, name: recipe_name)
      recipe_ingredient_list
      assign_family
      render(status: 201, json: Api::V1::RecipeSerializer.new(@recipe).attributes)
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

  def tag_list
    @recipe.tags << Tag.create_list(params[:tags])
  end

  def assign_family
    @recipe.assign_family
  end

  def recipe_ingredient_list
    @recipe.recipe_ingredient_list(params[:recipe][:ingredients])
  end

  def ingredient_list
    Ingredient.create_list(params[:recipe][:ingredients].keys)
  end

  def recipe_activity
    user = current_user.id
    client = Stream::Client.new(ENV['STREAM_KEY'], ENV['STREAM_SECRET'])
    feed = client.feed('user', user)
    activity_data = { actor: user, verb: 'post', object: 1, post: "#{current_user.name} created a new recipe" }
    feed.add_activity(activity_data)
  end
end
