# frozen_string_literal: true

# features/step_definitions/time_slot_steps.rb

Given('I am on the time slot form page') do
  visit new_time_slot_path
  @initial_time_slot_count = TimeSlot.count
end

Given('I am on the time slot index page') do
  visit time_slots_path
end


Given('I am a logged in admin') do
  admin_user = User.create!(first: 'Test', last: 'Admin', email: 'testadmin@gmail.com', student: false, donor: true, admin: true)

  # Configure OmniAuth for testing
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '123545',
    info: {
      email: 'testadmin@gmail.com',
      first_name: 'Test',
      last_name: 'Admin',
      name: 'Test Admin'
    },
    extra: {
      raw_info: {
        admin: true
      }
    }
  })
  visit('/')
  click_on 'Login'
end


When('I fill in the start time with {string}') do |start_time|
  fill_in 'time_slot_start_time', with: start_time
end

When('I fill in the end time with {string}') do |end_time|
  fill_in 'time_slot_end_time', with: end_time
end

When('I click the {string} button') do |button_text|
  click_button button_text
end

When('I add a time slot with start time {string} and end time {string}') do |start_time, end_time|
  fill_in 'time_slot_start_time', with: start_time
  fill_in 'time_slot_end_time', with: end_time
  click_button 'Add Another Time Slot'
end

When('I delete the first time slot') do
  within(first('#form-container')) do
    click_button 'Delete Time Slot'
  end
end

Then('I should see {string} on the time slots index page') do |content|
  expect(page).to have_content(content)
end

Then('I should not see any time slots') do
  expect(page).not_to have_selector('.time-slot')
end

Then('I should be on the time slots index page') do
  expect(page).to have_current_path(time_slots_path)
end

Then('I should see a new time slot created') do
  expect(TimeSlot.count).to eq(@initial_time_slot_count + 1)
end

Then("I should see today's date on the screen") do
  today = Date.today
  expected_month_year = today.strftime('%B %Y')
  expect(page).to have_content(expected_month_year)
end

Then('I should see an alert saying {string}') do |alert_message|
  expect(page).to have_content(alert_message)
end

Then('I should still be on the new time slot page') do
  expect(page).to have_current_path(new_time_slot_path)
end
