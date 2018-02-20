require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  it {should validate_presence_of :amount}
end
