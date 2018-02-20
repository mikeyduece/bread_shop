require 'rails_helper'

describe 'User API' do
  before(:all) do
    @user = create(:user)
    @token = TokiToki.encode(@user.attributes)
  end
  context 'Authorization' do
    it 'should return token' do
      stub_omniauth
      get api_v1_auth_amazon_path, params: stub_omniauth

      expect(response).to be_success

      user_json = JSON.parse(response.body, symbolize_names: true)

      expect(user_json[:token]).to match(/^[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_]+)?$/)
    end
  end
end
