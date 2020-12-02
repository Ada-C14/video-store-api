require "test_helper"

describe CustomersController do
  CUSTOMER_FIELDS = ["id", "name", "phone", "postal_code", "registered_at", "videos_checked_out_count"].sort

  describe "index" do
    it "must get index" do
      get customers_path

      expect(response.header["Content-Type"]).must_include 'json'
      must_respond_with :ok
    end

    it "will return all the proper fields for a list of customers" do
      # Act
      get customers_path

      # Get the body of the response as an array or hash
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal CUSTOMER_FIELDS
      end
    end

    it "returns an empty array if no customers exist" do
      Customer.destroy_all

      # Act
      get customers_path

      # Get the body of the response as an array or hash
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0
      must_respond_with :ok
    end
  end
end
