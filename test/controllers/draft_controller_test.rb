require "test_helper"

class DraftControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get draft_login_url
    assert_response :success
  end
end
