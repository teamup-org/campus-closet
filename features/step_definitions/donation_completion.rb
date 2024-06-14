# frozen_string_literal: true

Given('I am on the donor dashboard') do
  href = find_link('Donor Dashboard')[:href]
  visit(href)
end

Given('I am on the student profile page') do
  visit('/')
  href = find_link('Student Profile')[:href]
  visit(href)
end


Given('there is a request for item {int} uploaded by user {int} from user {int}') do |item_id, donor_id, receiver_id|
  donor = User.find_by(id: donor_id)
  receiver = User.find_by(id: receiver_id)
  item = Item.find_by(id: item_id)
  
  time_slot = TimeSlot.first_or_create!(start_time: Time.now, end_time: Time.now + 1.hour)

  Request.create!(donor: donor, receiver: receiver, item: item, time_slot: time_slot)
end



When('I click the current request') do
  # simulate button press
  first_request = Request.find_by(id: 1)

  donor_id = first_request.donor_id
  donor = User.find(donor_id)
  receiver_id = first_request.receiver_id
  receiver = User.find(receiver_id)
  item_id = first_request.item_id
  item = Item.find(item_id)

  first_request.destroy
  Pickup.create(donor:, receiver:, item:)
  refresh
end

When('I click the Show Map') do
  expect(page).to have_content('Show Map')

  button = find('button.show-map-button')
  button.click(wait: 10)
end

Then('the map container should be visible') do
  map_container = find('.map_container', visible: :all)
  expect(map_container).to be_visible
end

Then('the map container should not be visible') do
  map_container = find('.map_container', visible: :all)
  expect(map_container.visible?).not_to be eq(true)
end

Then('a past pickup should be created') do
  expect(page).not_to have_content('No Past Pickups')
end

Given('there is a past pickup for item {int} uploaded by {int} from user {int}') do |item_id, donor_id, receiver_id|
  donor = User.find(donor_id)
  receiver = User.find(receiver_id)
  item = Item.find(item_id)
  Pickup.create(donor:, receiver:, item:)
end

Then('I should see a past pickup') do
  expect(page).not_to have_content('No Past Pickups')
end

Then('I should no longer see a current request') do
  expect(page).to have_content('No Current Requests')
end
