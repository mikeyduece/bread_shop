class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :uid, uniqueness: true
  has_many :recipes

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
end
