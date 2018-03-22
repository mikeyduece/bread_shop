class Api::V1::GroupedRecipeSerializer < ActiveModel::Serializer
  #attr_reader :families

  #def families
    #hash = {}
    #@instance_options[:families].each do |family, recipes|
      #hash[family] = serialized_recipes(recipes)
    #end.to_h
    #hash
  #end

  #private

    #def serialized_recipes(recipes)
      #recipes.map {|recipe| Api::V1::RecipeSerializer.new(recipe, root: false) }
    #end
end
