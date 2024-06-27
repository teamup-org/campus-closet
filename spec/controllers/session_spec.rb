# frozen_string_literal: true

# spec/controllers/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#destroy' do
    it 'clears the session and redirects to Auth0 logout URL' do
      user = User.new(
        first: 'John',
        last: 'Doe',
        email: 'john.doe@example.com',
        student: true
      )

      session[:user_id] = user.id

      delete :destroy
      
      auth0_domain = ENV['AUTH0_DOMAIN']
      client_id = ENV['AUTH0_CLIENT_ID']
      return_to = root_url
      expected_logout_url = "https://#{auth0_domain}/v2/logout?client_id=#{client_id}&returnTo=#{return_to}"

      expect(response).to redirect_to(expected_logout_url)
    end
  end
end
