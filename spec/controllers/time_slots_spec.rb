# frozen_string_literal: true

# spec/controllers/time_slots_controller_spec.rb

require 'rails_helper'

RSpec.describe TimeSlotsController, type: :controller do
  before do
    allow(controller).to receive(:require_admin)
  end
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :auth0,
        uid: 'auth0|123456789',
        provider: 'auth0',
        info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
      )
    
      user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      time_slot = TimeSlot.create(
        donor: user,
        start_time: DateTime.now.beginning_of_hour + 1.day,
        end_time: DateTime.now.beginning_of_hour + 25.hours,
        status: 'available'
      )
      get :show, params: { id: time_slot.id }
      expect(response).to be_successful
    end
    
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :auth0,
        uid: 'auth0|123456789',
        provider: 'auth0',
        info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
      )
    
      user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      time_slot = TimeSlot.create(
        donor: user,
        start_time: DateTime.now.beginning_of_hour + 1.day,
        end_time: DateTime.now.beginning_of_hour + 25.hours,
        status: 'available'
      )
      get :edit, params: { id: time_slot.id }
      expect(response).to be_successful
    end
  
  end

  describe 'DELETE #destroy' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :auth0,
      uid: 'auth0|123456789',
      provider: 'auth0',
      info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
    )
    
    user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
    
    time_slot = TimeSlot.create(
      donor: user,
      start_time: DateTime.now.beginning_of_hour + 1.day,
      end_time: DateTime.now.beginning_of_hour + 25.hours,
      status: 'available'
    )

    it 'destroys the time slot' do
      expect do
        delete :destroy, params: { id: time_slot.id }
      end.to change(TimeSlot, :count).by(-1)
    end

    it 'redirects to the time slots list' do
      delete :destroy, params: { id: time_slot.id }
      expect(response).to redirect_to(time_slots_url)
      expect(flash[:notice]).to eq('Time slot was successfully destroyed.')
    end
  end

  describe 'PATCH/PUT #update' do
    let(:user) do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :auth0,
        uid: 'auth0|123456789',
        provider: 'auth0',
        info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
      )
      donor_user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      session[:user_id] = donor_user.id
      donor_user
    end

    let(:time_slot) do
      TimeSlot.create(
        donor: user,
        start_time: DateTime.now.beginning_of_hour + 1.day,
        end_time: DateTime.now.beginning_of_hour + 25.hours,
        status: 'available'
      )
    end
  end

  describe 'POST #create' do
    context 'when the user is authenticated' do
      let(:user) do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(
          :auth0,
          uid: 'auth0|123456789',
          provider: 'auth0',
          info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
        )
        User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      end

      before do
        session[:user_id] = user.id
      end

      context 'with valid params' do
        let(:valid_params) do
          { time_slot: { start_time: Time.now + 1.hour } }
        end

        it 'creates a new TimeSlot' do
          expect do
            post :create, params: valid_params
          end.to change(TimeSlot, :count).by(1)
        end

        it 'redirects to the user_donor_path' do
          post :create, params: valid_params
          expect(response).to redirect_to(user_donor_path(user))
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          { time_slot: { start_time: '' } }
        end

        it 'does not create a new TimeSlot' do
          expect do
            post :create, params: invalid_params
          end.to_not change(TimeSlot, :count)
        end

        it 're-renders the new template' do
          post :create, params: invalid_params
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'when the user is authenticated' do
      let(:user) do
        OmniAuth.config.test_mode = true
        OmniAuth.config.add_mock(
          :auth0,
          uid: 'auth0|123456789',
          provider: 'auth0',
          info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
        )
        User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
      end
      

      let(:time_slot) do
        TimeSlot.create(
          donor: user,
          start_time: DateTime.now.beginning_of_hour + 1.day,
          end_time: DateTime.now.beginning_of_hour + 25.hours,
          status: 'available'
        )
      end

      before do
        session[:user_id] = user.id
      end

      context 'with valid params' do
        let(:valid_params) do
          { id: time_slot.id, time_slot: { start_time: (Time.now + 2.hours).to_s } }
        end

        it 'updates the TimeSlot' do
          put :update, params: valid_params
          time_slot.reload
          expect(time_slot.start_time.to_i).to eq(Time.zone.parse(valid_params[:time_slot][:start_time]).to_i)
        end

        it 'redirects to the TimeSlot show path' do
          put :update, params: valid_params
          expect(response).to redirect_to(time_slot_url(time_slot))
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          { id: time_slot.id, time_slot: { start_time: nil } }
        end

        it 'does not update the TimeSlot' do
          original_start_time = time_slot.start_time
          put :update, params: invalid_params
          time_slot.reload
          expect(time_slot.start_time).not_to eq(original_start_time)
        end
      end
    end
  end

  describe 'PUT #mark_unavailable' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :auth0,
      uid: 'auth0|123456789',
      provider: 'auth0',
      info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
    )
    
    user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])
    
    time_slot = TimeSlot.create(
      donor: user,
      start_time: DateTime.now.beginning_of_hour + 1.day,
      end_time: DateTime.now.beginning_of_hour + 25.hours,
      status: 'available'
    )

    context 'when the time slot is successfully marked as unavailable' do
      before do
        put :mark_unavailable, params: { id: time_slot.id }
        time_slot.reload
      end

      it 'returns a success message' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Time slot marked as unavailable.')
      end

      it 'marks the time slot as unavailable' do
        expect(time_slot.status).to eq('unavailable')
      end
    end

    context 'when the time slot cannot be marked as unavailable' do
      before do
        allow_any_instance_of(TimeSlot).to receive(:update).and_return(false)
        put :mark_unavailable, params: { id: time_slot.id }
      end

      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Failed to mark time slot as unavailable. Please try again.')
      end
    end
  end
  describe '#build_time_slot' do

    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(
      :auth0,
      uid: 'auth0|123456789',
      provider: 'auth0',
      info: { email: 'testdonor@tamu.edu', name: 'Test Donor' }
    )

    user = User.from_omniauth(OmniAuth.config.mock_auth[:auth0])

    it 'builds a new time slot for the current user with status "available"' do
      time_slot_param = { start_time: Time.now, end_time: Time.now + 1.hour }
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      time_slot = controller.send(:build_time_slot, time_slot_param)

      expect(time_slot.status).to eq('available')
    end
  end
end
