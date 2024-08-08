# frozen_string_literal: true

Given('the following admin emails exist:') do |table|
  table.hashes.each do |row|
    email = row['email']
    if email.include?('admin')
      User.create!(first: 'Test', last: 'Admin', email: email, student: false, donor: true, admin: true)
    else
      User.create!(first: 'Test', last: 'User', email: email, student: false, donor: true)
    end
  end
end


Given('I try to go to the users index page') do
  visit('/users')
end

Then('I should be redirected to the index page') do
  expect(page).to have_content('Size:')
end

Then("there should be an alert that says 'You don't have permission to view this page.'") do
  expect(page).to have_text('You don\'t have permission to view this page.')
end

Then('I should still be on the users page') do
  expect(page).to have_content('Users')
end

Then('I should see a list of users') do
  expect(page).to have_content('Show this user')
end

Then('I should see a {string} button') do |btn_name|
  find_button(btn_name)
end

Given('I try to go to the reviews index page') do
  visit('/reviews')
end

Then('I show the first user') do
  click_link('Show this user', href: '/users/1')
end
