# frozen_string_literal: true

Then('I should be on a new item page') do
  expect(page).to have_current_path('/items/5') # 4 items + the 1 new item
end

Then('my name should be assigned') do
  expect(page).to have_content('Donor: Test Donor')
end

Then('I should return back to the homepage') do
  expect(page).to have_current_path('/')
end
