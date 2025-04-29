require "test_helper"

class TaxCalculatorControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get tax_calculator_home_url
    assert_response :success
  end
end
