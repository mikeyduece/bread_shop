# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :uid, uniqueness: true
  has_many :recipes
  has_many :follows, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  def self.from_auth(auth)
    info = auth[:info]
    unless user ||= find_by(email: info[:email])
      user = create(
        name: info[:name],
        email: info[:email],
        zipcode: info[:postal_code],
        uid: auth[:uid]
      )
    end
    user
  end

  def followed_by(user = nil)
    return true if user.follows.find_by(target_id: id)
  end
end
