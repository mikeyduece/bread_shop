require 'rails_helper'

RSpec.describe Tag, 'validations' do
  it { should validate_presence_of :name }
end

