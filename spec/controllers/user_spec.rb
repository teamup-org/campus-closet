# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, user: :controller do
  let(:user) { User.create(first: 'Example User', email: 'example@tamu.edu') }
  let(:non_tamu_user) { User.create(first: 'Non TAMU User', email: 'non_tamu@example.com') }

  before do
    allow(controller).to receive(:require_admin)
    allow(controller).to receive(:require_login)
  end

  describe 'GET #account_creation' do
    context 'when user has a tamu.edu email' do
      it 'does not update donor status' do
        get :account_creation, params: { id: user.id }
        user.reload
        expect(user.donor).to be_falsey
      end
    end

    context 'when user does not have a tamu.edu email' do
      it 'updates donor status to true' do
        get :account_creation, params: { id: non_tamu_user.id }
        non_tamu_user.reload
        expect(non_tamu_user.donor).to be_truthy
      end
    end
  end

  describe 'PATCH #update_user' do
    context 'with valid params' do
      it 'updates the user and redirects to root_path' do
        patch :update_user, params: { id: user.id, user: { first: 'Updated Name' } }
        user.reload
        expect(user.first).to eq('Updated Name')
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Account created successfully. Welcome to Campus Closet, #{user.first}!")
      end

      it 'updates the student status based on email' do
        patch :update_user, params: { id: user.id, user: { email: 'updated@tamu.edu' } }
        user.reload
        expect(user.student).to be_truthy
      end
    end

    context 'with invalid params' do
      it 'does not update the user and re-renders the edit template' do
        user = User.create(first: 'Test User', email: 'testuser@tamu.edu')
        allow_any_instance_of(User).to receive(:update).and_return(false) # Simulate failure
  
        patch :update_user, params: { id: user.id, user: { first: '' } }
  
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #show_student' do
    it 'renders the show_student template' do
      get :show_student, params: { id: user.id }
      expect(response).to render_template('show_student')
    end
  end

  describe 'GET #show_donor' do
    it 'renders the show_donor template' do
      get :show_donor, params: { id: user.id }
      expect(response).to render_template('show_donor')
    end
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
      allow(controller).to receive(:current_user).and_return(nil) # Simulate no logged-in user

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

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the user and redirects to user' do
        patch :update, params: { id: user.id, user: { first: 'Updated Name' } }
        user.reload
        expect(user.first).to eq('Updated Name')
        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq('Profile updated successfully.')
      end
    end

    context 'with invalid params' do
      it 'does not update the user and re-renders the edit template' do
        allow_any_instance_of(User).to receive(:update).and_return(false) # Simulate failure

        patch :update, params: { id: user.id, user: { first: '' } }

        expect(response).to render_template(:edit)
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

    it 'does not destroy the user and redirects with an alert if there are dependent records' do
      user = User.create(first: 'Example User')
      
      # Simulate dependent records by raising an ActiveRecord::InvalidForeignKey error
      allow_any_instance_of(User).to receive(:destroy).and_raise(ActiveRecord::InvalidForeignKey)
  
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to_not change(User, :count)
  
      expect(response).to redirect_to(users_url)
      expect(flash[:alert]).to eq("Cannot delete user because dependent records exist.")
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
