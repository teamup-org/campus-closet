# spec/controllers/auth0_controller_spec.rb

require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  describe 'GET #failure' do
    it 'sets the error message from request params' do
      get :failure, params: { message: 'Authentication failed' }

      expect(assigns(:error_msg)).to eq('Authentication failed')
    end
  end
end
