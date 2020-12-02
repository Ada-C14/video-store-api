require "test_helper"

describe CustomersController do
  CUSTOMER_FIELDS = %w[id name registered_at postal_code phone videos_checked_out_count].sort

  describe "index" do

    it "responds with success" do
      get customers_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "will return all the proper fields for a list of customer" do
      get customers_path

      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys).must_equal CUSTOMER_FIELDS
      end
    end

    it "return an empty arr if no pets" do
      Customer.destroy_all

      get customers_path
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0
      expect(body).must_equal []
    end
  end
end
