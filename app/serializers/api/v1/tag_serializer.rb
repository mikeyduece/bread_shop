class Api::V1::TagSerializer < ActiveModel::Serializer
  attribute :name
  has_many :recipes
end
