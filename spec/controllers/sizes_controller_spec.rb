# frozen_string_literal: true

RSpec.feature 'Size Selection', type: :feature do
  scenario 'Visiting the sizes page with a type_id parameter' do
    # Create test user with email
    user = User.create!(
      first: 'Test',
      last: 'Admin',
      email: 'testadmin@gmail.com',
      student: false,
      donor: true,
      admin: true
    )

    # Configure OmniAuth for testing
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
      provider: 'auth0',
      uid: '123545',
      info: {
        email: user.email,
        first_name: user.first,
        last_name: user.last,
        name: 'Test Admin'
      }
    })

    # Visit root path and perform login
    visit '/'
    click_on 'Login'

    # Create type and sizes
    type = Type.create!(name: 'Example Type')
    Size.create!(name: 'S', type: type)
    Size.create!(name: 'M', type: type)

    # Visit sizes page with type_id parameter
    visit sizes_path(type_id: type.id)

    # Check for content on the page
    expect(page).to have_content('S')
    expect(page).to have_content('M')
  end
end
