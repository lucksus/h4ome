require 'test_helper'

class NamespaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get namespace_index_url
    assert_response :success
  end

  test "should get show" do
    get namespace_show_url
    assert_response :success
  end

  test "should get update" do
    get namespace_update_url
    assert_response :success
  end

end
