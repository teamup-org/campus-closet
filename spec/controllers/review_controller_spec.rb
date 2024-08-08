# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  before do
    allow(controller).to receive(:require_admin)
  end
  let(:donor) { User.create!(first: 'Example User1', donor: true, student: false) }
  let(:receiver) { User.create!(first: 'Example User2', student: true, donor: false) }
  let(:item) { create_item(donor) }
  let(:pickup) { Pickup.create!(donor:, receiver:, item:) }
  let(:valid_attributes) { { rating: 5, pickup_id: pickup.id, user_id: receiver.id, donor_id: donor.id } }
  let(:invalid_attributes) { { rating: nil, pickup_id: pickup.id, user_id: receiver.id, donor_id: donor.id } }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      review = Review.create!(valid_attributes)
      get :show, params: { id: review.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Review' do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(
          :auth0,
          uid: 'auth0|123456789',
          provider: 'auth0',
          info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
        )
        user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
        session[:user_id] = user.id
        
        expect do
          post :create, params: { review: valid_attributes }
        end.to change(Review, :count).by(1)
      end
    end
  

    context 'with invalid params' do
      it 'does not create a new Review' do
        expect do
          post :create, params: { review: invalid_attributes }
        end.to change(Review, :count).by(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested review' do
      review = Review.create!(valid_attributes)
      expect do
        delete :destroy, params: { id: review.to_param }
      end.to change(Review, :count).by(-1)
    end

    it 'redirects to the reviews list' do
      review = Review.create!(valid_attributes)
      delete :destroy, params: { id: review.to_param }
      expect(response).to redirect_to(reviews_url)
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      let(:review) { Review.create!(valid_attributes) }

      it 'updates the requested review' do
        new_rating = 4
        patch :update, params: { id: review.to_param, review: { rating: new_rating } }
        review.reload
        expect(review.rating).to eq(new_rating)
      end

      it 'redirects to the review' do
        patch :update, params: { id: review.to_param, review: valid_attributes }
        expect(response).to redirect_to(review_url(review))
      end
    end

    context 'with invalid params' do
      let(:review) { Review.create!(valid_attributes) }

      it 'renders the edit template' do
        patch :update, params: { id: review.to_param, review: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end
end
