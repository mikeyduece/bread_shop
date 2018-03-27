class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :name, :family
  belongs_to :user
end
