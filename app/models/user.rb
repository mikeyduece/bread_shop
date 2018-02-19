class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :uid, uniqueness: true
end
