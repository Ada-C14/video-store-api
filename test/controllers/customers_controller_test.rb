require "test_helper"

describe CustomersController do
  describe 'index' do
    it "must get index" do
      # Act
      get customers_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Customer.count

      # Check that each customer has the proper keys
      fields = ["id", "name", "registered_at", "postal_code",
        "phone", "videos_checked_out_count"].sort

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
      end

      must_respond_with :ok
    end

    it 'responds with JSON and success' do
      get customers_path

      expect(response.header['Content-Type']).must_include 'json'
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

  describe 'show' do
    # nominal
    it 'should return a hash with proper fields for an existing customer' do
      fields = ["id", "name", "registered_at", "postal_code",
                "phone", "videos_checked_out_count"].sort

      customer = customers(:customer_one)

      # Act
      get customer_path(customer.id)

      body = JSON.parse(response.body)

      must_respond_with :ok
      expect(response.header['Content-Type']).must_include 'json'

      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal fields.sort

    end

    # edge case
    it 'should respond with not_found if no customer matches the id' do

      # Act
      get customer_path(-1)

      must_respond_with :not_found
      body = JSON.parse(response.body)

      # Then you can test for the json in the body of the response
      expect(body['ok']).must_equal false
      expect(body['message']).must_include 'Not Found'
    end
  end
end
