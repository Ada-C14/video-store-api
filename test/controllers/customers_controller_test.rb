require "test_helper"

describe CustomersController do
  CUSTOMER_FIELDS =  ["id", "name", "registered_at", "postal_code", "phone", "videos_checked_out_count"].sort

  describe "index" do
    it "must get index" do
      get customers_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "will return all the proper fields for a list of customers" do
      # Act
      get customers_path
      body = JSON.parse(response.body)
      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Customer.count

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        # Ensures that each response has only the id, name, registered_at, postal_code, etc.
        expect(customer.keys.sort).must_equal CUSTOMER_FIELDS.sort
        must_respond_with :ok
      end
    end

    it "will respond with an empty array if there are no customers" do
      # Arrange
      Customer.destroy_all
      # Act
      get customers_path
      body = JSON.parse(response.body)
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
      must_respond_with :ok
    end
  end

  describe "show" do
    # # #Nominal test case
    it "will return a hash with the proper fields for an existing customer" do
      customer = customers(:customer_one)
      #Act
      get customer_path(customer.id)

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'

      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal CUSTOMER_FIELDS.sort
    end

    # Edge case
    it "will return 404 with JSON for a non-existent customer" do
      get customer_path(-1)

      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["ok"]).must_equal false
      expect(body["errors"]).must_equal "Not Found"
    end
  end

end


