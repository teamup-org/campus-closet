require "test_helper"

class CarouselControllerTest < ActionDispatch::IntegrationTest
  test "should get page" do
    get carousel_page_url
    assert_response :success
  end
end
