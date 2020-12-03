require "test_helper"

describe CustomersController do

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "index" do
    it "must get index" do
      # Act
      get customers_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Customer.count

      # Check that each customer has the proper keys
      fields = ["name", "address", "city", "state", "postal_code",
        "phone", "registered_at", "videos_checked_out_count"].sort

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
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

  describe "create" do
    let(:customer_data) {
      {
        customer: {
          name: "Test Customer Name",
          postal_code: "12345",
          phone: "(123)456-7890"
        }
      }
    }

    it "can create a new customer" do
      expect {
        post customers_path, params: customer_data
      }.must_differ "Customer.count", 1

      check_response(expected_type: Hash, expected_status: :created)
    end

    it "will respond with bad_request for invalid data" do
      # Arrange - using let from above
      # Our CustomersController test should just test generically
      # for any kind of invalid data, so we will randomly pick
      # the name attribute to invalidate
      customer_data[:customer][:phone] = nil

      expect {
        # Act
        post customers_path, params: customer_data

        # Assert
      }.wont_change "Customer.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "name"
    end

  end

  describe "show" do
    it "responds with JSON, success, and customer data when looking for one existing customer" do
      existing_customer = Customer.first

      get customer_path(existing_customer.id)

      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal ["id", "name", "registered_at", "address", "city", "state", "postal_code", "phone", "videos_checked_out_count"].sort
      expect(body["id"]).must_equal existing_customer.id
      expect(body["name"]).must_equal existing_customer.name
      expect(body["registered_at"]).must_equal existing_customer.registered_at
      expect(body["postal_code"]).must_equal existing_customer.postal_code
      expect(body["phone"]).must_equal existing_customer.phone
      expect(body["videos_checked_out_count"]).must_equal existing_customer.videos_checked_out_count
    end

    it "responds with JSON, not found, and errors when looking for non-extant customer" do
      get customer_path(-1)

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["ok"]).must_equal false
      expect(body["errors"]).must_include "Not Found"
    end
  end
end

# end
