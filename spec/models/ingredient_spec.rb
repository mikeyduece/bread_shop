require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it {should validate_uniqueness_of :name}
end
