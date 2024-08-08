# frozen_string_literal: true

Given('the following emails have an account associated with them:') do |table|
  table.hashes.each do |row|
    email = row['email']
    if email.ends_with?('.com')
      User.create!(first: 'Test', last: 'Donor', email: email, student: false, donor: true, address: '125 Spence St, College Station, TX 77843')
    else
      User.create!(first: 'Test', last: 'Student', email: email, student: true, donor: false, address: '907 Cross St, College Station, TX 77840')
    end
  end
end

Given('I am on the Login page') do
  visit('/')
end

When('I click {string}, {string}') do |link, email|
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '123545',
    info: {
      email: email,
      first_name: 'Test',
      last_name: 'User',
      name: 'Test User'
    }
  })
  click_on link
end

Then('I should be logged in') do
  expect(page.driver.request.session['user_id']).to_not be_nil
end

Then('I should be put on the account creation page') do
  user_id = page.driver.request.session['user_id']
  expect(page).to have_current_path("/users/#{user_id}/account_creation")
end

Then('I should be put on the homepage') do
  expect(page).to have_current_path('/')
end

Given('I have an account, {string}') do |email|
  user_exists = User.where(email: email).exists?
  expect(user_exists).to eq(true)
end

Given('I do not have an account already, {string}') do |email|
  user_exists = User.where(email: email).exists?
  expect(user_exists).to eq(false)
end

Given('I am on the account creation page, {string}') do |email|
  visit('/')
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '123545',
    info: {
      email: email,
      first_name: 'Test',
      last_name: 'User',
      name: 'Test User'
    }
  })
  click_on 'Login'
end

When('I enter {string} in {string}') do |value, field|
  fill_in field, with: value
end
