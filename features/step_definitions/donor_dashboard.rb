# frozen_string_literal: true

Given('I am a logged in donor') do
  donor_user=User.create!(first: 'Test', last: 'Donor', email: 'testdonor@gmail.com', student: false, donor: true)
  
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
    provider: 'auth0',
    uid: '545',
    info: {
      email: 'testdonor@gmail.com',
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

  @current_user = donor_user

end

Given('I am on the Dashboard') do
  dash = "/users/#{page.driver.request.session['user_id']}/donor"
  visit(dash)
end

When('I fill in the {string} field with {string}') do |field, val|
  fill_in field, with: val
end

Then('I should see {string} as my {string}') do |val, _string2|
  expect(page).to have_content(val)
end
