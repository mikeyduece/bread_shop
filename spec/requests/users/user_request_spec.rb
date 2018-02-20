require 'rails_helper'

describe 'User API' do
  before(:all) do
    @user = create(:user)
    @token = TokiToki.encode(@user.attributes)
  end
  context 'Authorization' do
    it 'should return token' do
      stub_omniauth
      get login_path

      expect(response).to be_success

      user_json = JSON.parse(repsonse.body, symbolize_names: true)

      expect(user_json[:token]).to match(/[0-9a-f]{32,}/)
    end
  end
end
