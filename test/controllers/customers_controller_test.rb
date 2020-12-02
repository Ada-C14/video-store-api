require "test_helper"

describe CustomersController do
  let(:customer1) { customers(:customer_one) }
  let(:customer2) { customers(:customer_two) }

  describe "index" do
    it "must get index" do
      # Act
      get customers_path
      body = JSON.parse(response.body)

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Customer.count

      # Check that each customer has the proper keys
      fields = ["id", "name", "registered_at", "address", "city", "state","postal_code", "phone", "videos_checked_out_count"].sort

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
      end

      must_respond_with :ok
    end

    it "index works even with no customers" do
      Customer.destroy_all

      get customers_path

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0

      must_respond_with :ok
    end
  end

  describe "show" do
    it "should show an existing customer" do
      get customer_path(customer1.id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["name"]).must_equal "Simon Del Rosario"
      expect(body["registered_at"]).must_equal "2015-04-29T14:54:14.000Z"
      expect(body["postal_code"]).must_equal "75007"
      expect(body["phone"]).must_equal "(469) 734-9111"
      expect(body["address"]).must_equal "1314 Elm Street"
      expect(body["city"]).must_equal "Seattle"
      expect(body["state"]).must_equal "WA"
      expect(body["videos_checked_out_count"]).must_equal 3

      must_respond_with :ok
    end
    it "should return a descriptive json for a nonexisting customer" do
      get customer_path(-1)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['message']).must_equal "Customer not found"

      must_respond_with :not_found
    end
  end

  describe "create" do
    it "should create customer" do
      value do
        post customers_url, params: { customer: { create: @customer.create, index: @customer.index, show: @customer.show } }, as: :json
      end.must_differ "Customer.count"

      must_respond_with 201
    end
  end

end
