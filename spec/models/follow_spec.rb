# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Follow, 'validations' do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :target_id }
end

RSpec.describe Follow, 'associations' do
  it { should belong_to(:user) }
  it { should belong_to(:target) }
end
