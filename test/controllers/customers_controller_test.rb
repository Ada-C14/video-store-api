require "test_helper"

describe CustomersController do

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header["Content-Type"]).must_include "json"

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  it "must get index" do
    # Check that each customer has the proper keys
    CUSTOMER_FIELDS = ["id", "name", "registered_at", "postal_code", 
      "phone", "videos_checked_out_count"].sort

    # Act
    get customers_path

    # Assert
    body = check_response(expected_type: Array)
    expect(body.length).must_equal Customer.count

    body.each do |customer|
      expect(customer.keys.sort).must_equal CUSTOMER_FIELDS
    end
  end

  it "works even with no customers" do
    # Arrange
    Customer.destroy_all
    # Act
    get customers_path
    # Assert
    body = check_response(expected_type: Array)
    expect(body.length).must_equal 0
  end

end
