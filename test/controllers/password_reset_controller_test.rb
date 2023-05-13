require "test_helper"

class PasswordResetControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get password_reset_create_url
    assert_response :success
  end

  test "should get update" do
    get password_reset_update_url
    assert_response :success
  end
end
