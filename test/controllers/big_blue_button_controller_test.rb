require 'test_helper'

class BigBlueButtonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get big_blue_button_index_url
    assert_response :success
  end

end
