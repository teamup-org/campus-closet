require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get page" do
    get welcome_page_url
    assert_response :success
  end
end
