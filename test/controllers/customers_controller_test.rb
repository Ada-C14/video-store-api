require "test_helper"

describe CustomersController do
  # Check that each customer has the proper keys
  FIELDS = ["id", "name", "registered_at", "postal_code",
            "phone", "videos_checked_out_count"].sort
  describe "index" do
    it "must get index" do
      # Act
      get customers_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Customer.count

      body.each do |customer|
        expect(customer.keys.sort).must_equal FIELDS
      end

      must_respond_with :ok
    end

    it "works even with no customers" do
      Customer.destroy_all

      get customers_path
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0

      must_respond_with :ok
    end
  end

  describe "show" do
    it "will return back a hash with the proper fields" do
      customer = customers(:customer_one)

      get customer_path(customer.id)

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(body).must_be_instance_of Hash
      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys.sort).must_equal FIELDS
    end
  end


end
