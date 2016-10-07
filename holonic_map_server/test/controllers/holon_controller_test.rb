require 'test_helper'

class HolonControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get holon_show_url
    assert_response :success
  end

  test "should get create" do
    get holon_create_url
    assert_response :success
  end

end
