class Api::V1::GroupedRecipeSerializer < ActiveModel::Serializer

  def serializable_hash
    @object.map do |family, recipes|
      [ family, serialized_recipe(recipes) ]
    end.to_h
  end

  private

    def serialized_recipe(recipes)
      recipes.map {|recipe| Api::V1::RecipeSerializer.new(recipe, root: false) }
    end
end
