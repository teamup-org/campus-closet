# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, user: :controller do
  before do
    allow(controller).to receive(:require_admin)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'when user is authorized' do
      it 'returns a success response for logged-in donor user' do
        user = User.create(first: 'Test Donor', email: 'testdonor@tamu.edu')
        allow(controller).to receive(:current_user).and_return(user)

        get :show, params: { id: user.id }

        expect(response).to be_successful
      end
    end

    context 'when user is not authorized' do
      it 'redirects to root_path with alert' do
        user = User.create(first: 'Other User', email: 'otheruser@tamu.edu')
        allow(controller).to receive(:current_user).and_return(nil)

        get :show, params: { id: user.id }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this user.')
      end
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response for logged-in user' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :auth0,
        uid: 'auth0|123456789',
        provider: 'auth0',
        info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
      )

      # Log in the user by creating a session
      user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      session[:user_id] = user.id

      get :edit, params: { id: user.id }

      expect(response).to be_successful
    end

    it 'redirects to root_path for unauthorized user' do
      user = User.create(first: 'Example User')
      get :edit, params: { id: user.to_param }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You don't have permission to view this profile.")
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: { first: 'New User', email: 'test@tamu.edu' } }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: { first: 'New User' } }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid parameters' do
      it "returns a success response (i.e., to display the 'new' template)" do
        post :create, params: { user: { first: nil } }
        expect(response).to_not be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      user = User.create(first: 'Example User')
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = User.create(first: 'Example User')
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
    end
  end

  describe 'PATCH #make_admin' do
    it 'makes the requested user an admin' do
      user = User.create(first: 'Example User')
      patch :make_admin, params: { id: user.to_param }
      user.reload
      expect(user.admin).to be_truthy
    end

    it 'redirects to the users list with a notice on success' do
      user = User.create(first: 'Example User')
      patch :make_admin, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
      expect(flash[:notice]).to eq('User successfully made admin.')
    end

    it 'redirects to the users list with an alert on failure' do
      allow_any_instance_of(User).to receive(:update).and_return(false)
      user = User.create(first: 'Example User')
      patch :make_admin, params: { id: user.to_param }
      expect(response).to redirect_to(users_url)
      expect(flash[:alert]).to eq('Failed to make user admin.')
    end
  end

  describe '#require_admin' do
    context 'when user is not an admin' do
      let(:basic_user) { User.create(first: 'Example User', admin: false) }

      before do
        allow(controller).to receive(:current_user).and_return(basic_user)
      end

      it 'redirects to root path with a flash message' do
        allow(controller).to receive(:require_admin).and_call_original
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You don\'t have permission to view this page.')
      end
    end

    context 'when user is an admin' do
      let(:admin) { User.create(first: 'Example User', admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin)
      end

      it 'does not redirect and allows the action to proceed' do
        get :index

        expect(response).to have_http_status(:success)
        expect(flash[:alert]).to be_nil
      end
    end
  end
end
