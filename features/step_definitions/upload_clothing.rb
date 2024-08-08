# frozen_string_literal: true

Given('I am on the items page') do
  visit('/items')
end


Given('I am logged in') do
  User.create!(first: 'Test', last: 'Donor', email: 'testdonor@gmail.edu', student: false, donor: true)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '435',
    info: {
      email: 'testdonor@gmail.com',
      first_name: 'Test',
      last_name: 'Donor',
      name: 'Test Donor'
    },
    extra: {
      raw_info: {
        student: false,
        donor: true
      }
    }
  })
  visit('/')
  click_on 'Login'
end

When('I click on {string}') do |button_text|
  click_on button_text
end

When('I am on the new item page') do
  expect(page).to have_current_path('/items/new')
end

Then('there should be a new item in the items page, {int}') do |int|
  items = Item.count + 1
  expect(items).to eq(int)
end

And('I include a picture') do
  attach_file('item_image', Rails.root.join('features', 'test_image', 'shirt.jpg'))
end

When('I fill in {string} with {string}') do |cat, value|
  select(value, from: "item_#{cat}_id")
end

Then('type should still be {string}') do |type|
  expect(page).to have_select('item_type_id', selected: type)
end

But('there should not be a picture') do
  expect(page).to have_content('No Image Available')
end

When('I fill in description with {string}') do |desc|
  fill_in 'item_description', with: desc
end
