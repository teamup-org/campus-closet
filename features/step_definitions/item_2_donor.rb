# frozen_string_literal: true

Then('I should be on a new item page') do
  expect(page).to have_current_path('/items/5') # 4 items + the 1 new item
end

Then('the item should be marked as donated by me') do
  # Implement logic to verify the item is associated with the logged-in donor
  # This could involve checking the item's details in the database or confirming
  # a specific UI element that shows the item is associated with the donor.
  item = Item.last
  expect(item.user_id).to eq(@current_user.id)
  # Alternatively, if there's a UI element:
  # expect(page).to have_content("Donated by You") # Adjust the content as per actual UI text
end

# Then('my name should be assigned') do
#   expect(page).to have_content('Donor: Test Donor')
# end

Then('I should return back to the homepage') do
  expect(page).to have_current_path('/')
end
