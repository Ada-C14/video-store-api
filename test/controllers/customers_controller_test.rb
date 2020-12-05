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

    it "it will return a not_found request if customer doesn't exist" do
      get customer_path(-1)

      body = JSON.parse(response.body)

      must_respond_with :not_found
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['message']).must_equal "Not Found"
    end
  end

  describe "create" do
    let(:customer_params) {
      {
        customer: {
            name: "Ryan Shubbawoo",
            registered_at: "2014-07-04T18:05:11.000Z",
            address: "308399 Bubble Road",
            city: "Seattle",
            state: "WA",
            postal_code: "98224",
            phone: "(206)986-2739",
            videos_checked_out_count: 5,
        },
      }
    }

    it "can create a new customer" do
      expect {
        post customers_path, params: customer_params
      }.must_differ "Customer.count", 1

      must_respond_with :created
    end

    it "can respond with a bad_request if customer gives bad data" do
      customer_params[:customer][:name] = nil

      expect {
        post customers_path, params: customer_params
      }.wont_change "Customer.count"

      must_respond_with :bad_request

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body['errors'].keys).must_include 'name'
    end
  end
end
