# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Requests' do
  let!(:users) { create_list(:user, 10) }
  subject(:user) { User.first }
  # TODO: Make this to where only an admin can see this list?
  it '#GET all users' do
    get '/api/v1/users/all'

    expect(response).to be_successful

    user_list = JSON.parse(response.body, symbolize_names: true)

    expect(user_list.count).to eq(10)
    expect(response.status).to eq(200)
  end

  it 'uploads file to user model' do
    file = fixture_file_upload(Rails.root.join('public', 'apple-touch-icon.png'), 'image/png')
    subject.avatar.attach(io: File.open(file), filename: 'rick_astley.png', content_type: 'image/png')
    
    expect(subject.avatar).to be_attached
  end
end
