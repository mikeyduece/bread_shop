require 'rails_helper'

RSpec.describe 'User Requests' do
  let!(:users) { create_list(:user, 10) }
  xit '#GET all users' do
    get '/api/v1/users/all'

    expect(response).to be_success
  end
end
