# frozen_string_literal: true

Given('the following items exist with user_ids:') do |table|
  table.hashes.each do |item_params|
    # find the object if it exists, otherwise create a new object
    color = Color.find_by(name: item_params['color']) || Color.create(name: item_params['color'])
    type = Type.find_by(name: item_params['type']) || Type.create(name: item_params['type'])
    gender = Gender.find_by(name: item_params['Gender']) || Gender.create(name: item_params['Gender'])
    status = Status.find_by(name: item_params['Status']) || Status.create(name: item_params['Status'])
    size = Size.find_by(name: item_params['Size']) || Size.create(name: item_params['Size'], type_id: Type.first.id)
    condition = Condition.find_by(name: item_params['Condition']) || Condition.create(name: item_params['Condition'])
    user = User.find_by(id: item_params['User'].to_i) || User.create(first: 'Test', last: 'User')

    # Create the item
    Item.create(
      color_id: color&.id,
      type_id: type&.id,
      gender_id: gender&.id,
      status_id: status&.id,
      size_id: size&.id,
      condition_id: condition&.id,
      description: item_params['Description'],
      image_url: 'https://pangaia.com/cdn/shop/files/Wool-Jersey-Oversized-Crew-Neck-Black-1.png?v=1694601739',
      user_id: user&.id
    )
  end
end

Given('I am logged in as a student') do
  User.create!(first: 'test', last: 'Student', email: 'test_student@tamu.edu', student: true, donor: false)
  
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '557',
    info: {
      email: 'test_student@tamu.edu',
      first_name: 'test',
      last_name: 'Student',
      name: 'test Student'
    },
    extra: {
      raw_info: {
        student: true,
        donor: false
      }
    }
  })
  visit('/')
  click_on 'Login'
end


Given('I am logged in as a donor') do
  donor = User.create!(first: 'Test', last: 'Donor', email: 'test_donor@gmail.com', student: false, donor: true)
  
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '556',
    info: {
      email: 'test_donor@gmail.com',
      first_name: 'Test',
      last_name: 'Donor',
      name: 'Test Donor'
    },
    extra: {
      raw_info: {
        donor: true
      }
    }
  })
  visit('/')
  click_on 'Login'
end

When('I click on a link with href {string} and text {string}') do |href_value, link_text|
  find("a[href='#{href_value}']", text: link_text).click
end

When('I click {string}') do |string|
  click_button(string)
end

Then('I should see the item details') do
  expect(page).to have_content('Color')
end

Given('there is a time slot from {string} to {string} for user with id {int}') do |start_time, end_time, user_id|
  TimeSlot.create(start_time:, end_time:, donor_id: user_id, status: 'available')
end

When('I click a time slot from {string} to {string}') do |_start_time, _end_time|
  first_time_slot = TimeSlot.find_by(id: 1)
  patch "/time_slots/#{first_time_slot.id}/mark_unavailable"

  # now create a request
  donor = first_time_slot.donor
  receiver = User.find_by(id: 2)
  item = Item.find_by(id: 1)
  Request.create(donor:, receiver:, item:)
  visit('/users/2/student')
end

Then('I should see the donors availability') do
  expect(page).to have_content('Mon')
end

Then('I should be sent back to the items page') do
  expect(page).to have_content('Student Profile')
end

Then('a request should be successfully submitted') do
  expect(page).not_to have_content('No Current Requests')
end

Given('I have a donor account, {string}') do |email|
  user_exists = User.where(email:).exists?
  expect(user_exists).to eq(true)
end

Given('I have an item\(s) listed to be donated') do
  expect(page).to have_content('Color')
end

Given('a student requests an item') do
  donor = User.find_by(id: 1)
  receiver = User.find_by(id: 2)
  item = Item.find_by(id: 1)
  Request.create(donor:, receiver:, item:)
end

Given('I go to my profile page') do
  visit('/users/1/donor')
end

Then('I should see that item has been requested') do
  expect(page).not_to have_content('No Current Requests')
end

Then('the time slot should be marked unavailable') do
  first_time_slot = TimeSlot.find_by(id: 1)
  visit("/time_slots/#{first_time_slot.id}")
  expect(page).to have_content('Status: unavailable')
end
