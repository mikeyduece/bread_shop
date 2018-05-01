# frozen_string_literal: true

class User < ApplicationRecord
  # include StreamRails::Activity
  # as_activity

  validates :email, uniqueness: true
  validates :uid, uniqueness: true
  has_many :recipes
  has_many :follows, dependent: :destroy

  def self.from_auth(auth)
    user = find_by(email: auth[:info][:email])
    if user.nil?
      user = create(
        name: auth[:info][:name],
        email: auth[:info][:email],
        zipcode: auth[:info][:postal_code],
        uid: auth[:uid]
      )
    end

    user
  end

  def followed_by(user = nil)
    return true if user.follows.find_by(target_id: id)
  end
end
