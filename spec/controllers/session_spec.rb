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

  describe '#create' do
    let(:auth) { OmniAuth.config.mock_auth[:auth0] }

    before do
      request.env['omniauth.auth'] = auth
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(
        provider: 'auth0',
        uid: '12345',
        info: {
          email: 'john.doe@example.com',
          first: 'John',
          last: 'Doe'
        }
      )
    end

    context 'when user is a new record (student is nil)' do
      it 'redirects to account creation page' do
        user = User.new(
          first: 'John',
          last: 'Doe',
          email: 'john.doe@example.com',
          student: nil
        )

        # Set the ID for the user
        user.id = 1

        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:id).and_return(1)

        post :create

        expect(user.persisted?).to be_falsey # Ensure user is not saved
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(account_creation_user_url(user))
      end
    end

    context 'when user is not a new record (student is not nil)' do
      it 'updates the user if changed and redirects to root path with notice' do
        user = User.create!(
          first: 'John',
          last: 'Doe',
          email: 'john.doe@example.com',
          student: true
        )

        allow(User).to receive(:from_omniauth).and_return(user)
        allow(user).to receive(:changed?).and_return(true)
        allow(user).to receive(:save).and_return(true)

        post :create

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Welcome back, #{user.first}!")
      end
    end
  end
end
