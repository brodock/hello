require 'spec_helper'

RSpec.describe 'Security', type: :request do
  context 'PATCH /profile.json' do
    before(:each) do
      @auth_headers = { 'HTTP_ACCESS_TOKEN' => given_I_have_a_classic_access_token.token }
      mock_stateless!
    end

    it 'Role' do
      expect do
        patch '/hello/profile.json', params: { user: { role: 'webmaster' } }, headers: @auth_headers

        expect(response.status).to eq(200)
      end.not_to change { User.last.role }.from('user')
    end
  end
end
