# frozen_string_literal: true

module RecipeConcerns
  def tag_list
    @recipe.tags << Tag.create_list(params[:tags])
  end

  def assign_family
    @recipe.assign_family
  end

  def recipe_ingredient_list
    @recipe.recipe_ingredient_list(recipe_ing_params)
  end

  def ingredient_list
    Ingredient.create_list(ingredient_params)
  end

  def recipe_activity
    user = current_user.id
    client = Stream::Client.new(ENV['STREAM_KEY'], ENV['STREAM_SECRET'])
    feed = client.feed('user', user)
    activity_data = { actor: user, verb: 'post', object: 1, post: "#{current_user.name} created a new recipe" }
    feed.add_activity(activity_data)
  end
end
