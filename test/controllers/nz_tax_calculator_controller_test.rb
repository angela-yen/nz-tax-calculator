require "test_helper"

class NzTaxCalculatorControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get nz_tax_calculator_home_url
    assert_response :success
  end
end
