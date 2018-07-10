class Api::V1::FamilySerializer < ActiveModel::Serializer
  attribute :name
  #has_many :recipes
end
