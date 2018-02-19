class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :uid, uniqueness: true

  def self.from_auth(auth)
    user = find_by_email(auth['info']['email'])
    if user.nil?
      user = create(name: auth['info']['name'],
                    email: auth['info']['email'],
                    zipcode: auth['info']['email'],
                    uid: auth['uid'])
    end
    user
  end
end
