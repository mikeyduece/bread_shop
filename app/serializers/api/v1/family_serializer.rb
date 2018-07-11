class Api::V1::FamilySerializer < ActiveModel::Serializer
  attribute :name
  has_many :recipes

  def recipes
    object.recipes.map do |recipe|
      ::Api::V1::RecipeSerializer.new(recipe).attributes
    end
  end
end
