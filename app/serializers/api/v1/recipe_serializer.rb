# frozen_string_literal: true

class Api::V1::RecipeSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :user
  belongs_to :family
  has_many :tags

  def user
    object.user do |us|
      ::Api::V1::UserSerializer.new(us).attributes
    end
  end
end
