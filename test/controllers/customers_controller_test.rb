require "test_helper"

REQUIRED_CUSTOMER_FIELDS = ["id", "name", "registered_at", "postal_code", "phone", "videos_checked_out_count"].sort

describe CustomersController do
  describe "index" do
    it "responds with JSON and ok" do
      get customers_path

      check_response(expected_type: Array)
    end

    it "returns an array of customer hashes" do
      get customers_path

      body = check_response(expected_type: Array)

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal REQUIRED_CUSTOMER_FIELDS
      end
    end

    it "will respond with an empty array when there are no customers" do
      Customer.destroy_all

      get customers_path

      body = check_response(expected_type: Array)
      expect(body).must_equal []
    end
  end
end
