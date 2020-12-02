require "test_helper"

describe CustomersController do
  let(:required_customer_attrs) {
    ["id", "name", "registered_at", "postal_code", "phone", "videos_checked_out_count"]
  }

  describe "index" do
    it "responds with JSON and ok" do
      get customers_path

      expect(response.header["Content-Type"]).must_include "json"
      must_respond_with 200
    end

    it "returns an array of customer hashes" do
      get customers_path

      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal required_customer_attrs.sort
      end
    end

    it "will respond with an empty array when there are no customers" do
      Customer.destroy_all

      get customers_path

      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      expect(body).must_equal []
      must_respond_with 200
    end
  end

end
