# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { User.create(first: 'Example User', donor: true, admin: true) }
  let!(:available_status) { Status.create(name: 'Available') } 
  let(:size) { Size.create(name: 'M', type: Type.create(name: 'Shirt')) }
  let(:color) { Color.create(name: 'Blue') }
  let(:condition) { Condition.create(name: 'New') }
  let(:gender) { Gender.create(name: 'Unisex') }

  before do
    @item_with_user = user.items.create(color: color, type: size.type,
                                        gender: gender,
                                        status: available_status,
                                        size: size,
                                        condition: condition)
    @another_item = user.items.create(color: Color.create(name: 'Red'), type: size.type,
                                        gender: Gender.create(name: 'Female'),
                                        status: available_status,
                                        size: Size.create(name: 'S', type: size.type),
                                        condition: Condition.create(name: 'Used'))
  end

  describe '#process_params_with_prefix' do
    let(:dummy_class) do
      Class.new do
        def self.find(id)
          { id:, name: "Item #{id}" }
        end
      end
    end
  end

  describe '#mark_unavailable' do
    let(:item) { create_item(user) }
    let(:status) { Status.create(name: 'Unavailable') }

    it 'marks the item as unavailable' do
      put :mark_unavailable, params: { id: item.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect(item.reload.status.name).to eq('Unavailable')
    end

    it 'creates a new status if "Unavailable" status does not exist' do
      Status.find_by(name: 'Unavailable')&.destroy

      put :mark_unavailable, params: { id: item.id }, format: :json

      expect(response).to have_http_status(:ok)
      expect(item.reload.status.name).to eq('Unavailable')
    end

    it 'renders unprocessable_entity if item save fails' do
      invalid_item = instance_double(Item, save: false, errors: { some: 'error' })
      allow(Item).to receive(:find).and_return(invalid_item)
      allow(invalid_item).to receive(:id).and_return(1)
      allow(invalid_item).to receive(:status=)

      Status.find_by(name: 'Unavailable')

      put :mark_unavailable, params: { id: invalid_item.id }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'some' => 'error' })
    end
  end

  describe '#authorize_item_edit' do
    let(:basic_user) { User.create(first: 'Example User', donor: true, admin: false) }
    context 'when user is not authorized' do
      it 'sets flash alert and redirects' do
        allow(controller).to receive(:current_user).and_return(basic_user)
        allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('development'))

        get :edit, params: { id: @item_with_user.id }
        assert_redirected_to items_path # Assert redirection
        assert_equal 'You are not authorized to edit this item.', flash[:alert]
      end
    end
  end

  describe 'POST #create' do
    let(:item_params) do
      {
        color_id: Color.create(name: 'temp_color').id,
        type_id: Type.create(name: 'temp_type').id,
        gender_id: Gender.create(name: 'temp_gender').id,
        description: 'Item description',
        size_id: Size.create(name: 'temp_size', type_id: Type.first.id).id,
        condition_id: Condition.create(name: 'temp_cond').id
      }
    end

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'with valid params' do
      it 'creates a new item and uploads the image to S3' do
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')
        raise "File not found: #{file_path}" unless File.exist?(file_path)

        file = fixture_file_upload(file_path, 'image/jpeg')
        item_params_with_image = item_params.merge(image: file)

        s3_client = instance_double(Aws::S3::Resource)
        s3_bucket = instance_double(Aws::S3::Bucket)
        s3_object = instance_double(Aws::S3::Object, public_url: 'http://example.com/test_image.jpg')

        allow(Aws::S3::Resource).to receive(:new).and_return(s3_client)
        allow(s3_client).to receive(:bucket).and_return(s3_bucket)
        allow(s3_bucket).to receive(:object).and_return(s3_object)
        allow(s3_object).to receive(:upload_file)

        post :create, params: { item: item_params_with_image }

        expect(response).to redirect_to(assigns(:item))
        expect(assigns(:item).image_url).to eq('http://example.com/test_image.jpg')
        expect(assigns(:item).user).to eq(user)
        expect(assigns(:item).status.name).to eq('Available')
      end
    end

    context 'with invalid params' do
      it 'renders the new template' do
        allow_any_instance_of(Item).to receive(:save).and_return(false)
        post :create, params: { item: item_params }

        expect(response).to render_template(:new)
      end
    end
  end

  describe '#pickup_request' do
    it 'assigns the correct time slots to @time_slots' do
      user = User.create(first: 'Test User')
      size = Size.create(name: 'M', type: Type.create(name: 'Shirt'))
      item = user.items.create(color: Color.create(name: 'Blue'), type: size.type, gender: Gender.create(name: 'Unisex'), status: Status.create(name: 'Available'), size: size, condition: Condition.create(name: 'New'))
      time_slot1 = user.time_slots.create(start_time: Time.now + 1.day, end_time: Time.now + 1.day + 1.hour)
      time_slot2 = user.time_slots.create(start_time: Time.now + 2.days, end_time: Time.now + 2.days + 1.hour)

      get :pickup_request, params: { id: item.id }

      expect(assigns(:time_slots)).to match_array([time_slot1, time_slot2])
    end

    it 'renders the pickup_request template' do
      user = User.create(first: 'Test User')
      size = Size.create(name: 'M', type: Type.create(name: 'Shirt'))
      item = user.items.create(color: Color.create(name: 'Blue'), type: size.type, gender: Gender.create(name: 'Unisex'), status: Status.create(name: 'Available'), size: size, condition: Condition.create(name: 'New'))

      get :pickup_request, params: { id: item.id }

      expect(response).to render_template(:pickup_request)
    end
  end

  describe '#filter_items' do
    it 'filters items by size' do
      controller.instance_variable_set(:@items, Item.all)
      controller.send(:filter_items, size.id, nil, nil, nil)
      expect(assigns(:items)).to match_array([@item_with_user])
    end

    it 'filters items by color' do
      controller.instance_variable_set(:@items, Item.all)
      controller.send(:filter_items, nil, color.id, nil, nil)
      expect(assigns(:items)).to match_array([@item_with_user])
    end

    it 'filters items by condition' do
      controller.instance_variable_set(:@items, Item.all)
      controller.send(:filter_items, nil, nil, condition.id, nil)
      expect(assigns(:items)).to match_array([@item_with_user])
    end

    it 'filters items by gender' do
      controller.instance_variable_set(:@items, Item.all)
      controller.send(:filter_items, nil, nil, nil, gender.id)
      expect(assigns(:items)).to match_array([@item_with_user])
    end

    it 'filters items by multiple attributes' do
      controller.instance_variable_set(:@items, Item.all)
      controller.send(:filter_items, size.id, color.id, condition.id, gender.id)
      expect(assigns(:items)).to match_array([@item_with_user])
    end
  end

  describe '#any_filters_present?' do
    it 'returns true if any filter params are present' do
      allow(controller).to receive(:params).and_return(size: size.id)
      expect(controller.send(:any_filters_present?)).to be true

      allow(controller).to receive(:params).and_return(color: color.id)
      expect(controller.send(:any_filters_present?)).to be true

      allow(controller).to receive(:params).and_return(condition: condition.id)
      expect(controller.send(:any_filters_present?)).to be true

      allow(controller).to receive(:params).and_return(gender: gender.id)
      expect(controller.send(:any_filters_present?)).to be true

      allow(controller).to receive(:params).and_return({})
      expect(controller.send(:any_filters_present?)).to be false
    end
  end

  describe '#apply_filters' do
    it 'calls filter_items with the correct parameters' do
      allow(controller).to receive(:params).and_return(size: size.id.to_s, color: color.id.to_s, condition: condition.id.to_s, gender: gender.id.to_s)
      expect(controller).to receive(:filter_items).with(size.id.to_s, color.id.to_s, condition.id.to_s, gender.id.to_s)
      controller.send(:apply_filters)
    end
  end

  describe '#by_type' do
    it 'finds the items by type' do
      get :by_type, params: { type: 'Shirt' }
      expect(assigns(:items)).to match_array([@item_with_user, @another_item])
    end

    it 'assigns sizes related to the type' do
      get :by_type, params: { type: 'Shirt' }
      expect(assigns(:sizes)).to match_array([size, @another_item.size])
    end

    it 'applies filters if any are present' do
      allow(controller).to receive(:params).and_return(type: 'Shirt', size: size.id.to_s)
      expect(controller).to receive(:apply_filters)
      get :by_type, params: { type: 'Shirt', size: size.id.to_s }
    end

    it 'does not apply filters if none are present' do
      allow(controller).to receive(:params).and_return(type: 'Shirt')
      expect(controller).not_to receive(:apply_filters)
      get :by_type, params: { type: 'Shirt' }
    end
  end
end
