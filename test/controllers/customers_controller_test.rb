require "test_helper"

describe CustomersController do
  # it "must get index" do
  #   # Act
  #   get customers_path
  #   body = JSON.parse(response.body)
  #
  #   # Assert
  #   expect(body).must_be_instance_of Array
  #   expect(body.length).must_equal Customer.count
  #
  #   # Check that each customer has the proper keys
  #   fields = ["id", "name", "registered_at", "postal_code",
  #     "phone", "videos_checked_out_count"].sort
  #
  #   body.each do |customer|
  #     expect(customer.keys.sort).must_equal fields
  #   end
  #
  #   must_respond_with :ok
  # end
  #
  # it "works even with no customers" do
  #   Customer.destroy_all
  #
  #   get customers_path
  #   body = JSON.parse(response.body)
  #
  #   expect(body).must_be_instance_of Array
  #   expect(body.length).must_equal 0
  #
  #   must_respond_with :ok
  # end

  CUSTOMER_FIELDS = ["id", "name", "registered_at", "address", "city", "state", "postal_code", "phone"].sort

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
    end
  end

  describe "show" do
    # Nominal
    it 'will return a hash with the proper fields for an existing customer' do
      customer = customers(:customer_one)

      get customer_path(customer.id)

      body = JSON.parse(response.body)

      must_respond_with :success
      expect(response.header["Content-Type"]).must_include 'json'

      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal CUSTOMER_FIELDS
    end

    # Edge
    it 'will return a 404 request with json for a non-existent customer' do
      get customer_path(-1)

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['message']).must_equal 'Not found'
    end
  end

  describe "create" do
    let(:customer_params) {
      {
          customer: {
              name: "Chris",
              registered_at: "Wed, 13 Mar 2020 07:54:14 -0700",
              postal_code: "98177",
              phone: "(469) 734-9222",
              videos_checked_out_count: 1,
              address: "1414 Seasame Street",
              city: "Seattle",
              state: "WA"
          }
      }
    }

    it 'can create a new customer' do
      expect{
        post customers_path, params: customer_params
      }.must_differ "Customer.count", 1

      must_respond_with :created
    end

    it 'gives bad request status when user gives bad data' do
      customer_params[:customer][:name] = nil

      expect{ post customers_path, params: customer_params }.wont_change "Customer.count"
      must_respond_with :bad_request

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "name"
    end
  end
end
