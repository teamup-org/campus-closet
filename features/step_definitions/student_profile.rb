# frozen_string_literal: true

# A lot of overlap with the donor dashboard feature
Given('I am a logged in student') do
  User.create!(first: 'Test', last: 'Student', email: 'teststudent@tamu.edu', student: true, donor: false)
  
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '630',
    info: {
      email: 'teststudent@tamu.edu',
      first_name: 'Test',
      last_name: 'Student',
      name: 'Test Student'
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

Then('I should see {string}') do |listing|
  expect(page).to have_content(listing)
end

Then('I should see my account details') do
  expect(page).to have_content('Account Details')
end

Given('I am on the Profile Page') do
  dash = "/users/#{page.driver.request.session['user_id']}/student"
  visit(dash)
end
