# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :uid, :zipcode
  has_many :recipes
  has_many :follows
end
