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
      fields = ["id", "name", "registered_at", "postal_code", "phone", "videos_checked_out_count"].sort

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
    let (:customer_hash) do
      {
          name: "Test Customer",
          registered_at: "2020-12-02 11:23:09 -0800",
          address: "123 Fake Street",
          city: "Seattle",
          state: "WA",
          postal_code: "99999",
          phone: "(123)456-7890",
          videos_checked_out_count: 1
      }
    end

    it "should create customer" do
      expect {
        post customers_path, params: customer_hash
      }.must_differ "Customer.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["name"]).must_equal customer_hash[:name]
      expect(Time.new(body["registered_at"])).must_equal Time.new(customer_hash[:registered_at])
      expect(body["postal_code"]).must_equal customer_hash[:postal_code]
      expect(body["phone"]).must_equal customer_hash[:phone]
      expect(body["address"]).must_equal customer_hash[:address]
      expect(body["city"]).must_equal customer_hash[:city]
      expect(body["state"]).must_equal customer_hash[:state]
      expect(body["videos_checked_out_count"]).must_equal customer_hash[:videos_checked_out_count]

      must_respond_with :created
    end

    it "will not create a customer with invalid params" do
      customer_hash[:phone] = nil

      expect {
        post customers_path, params: customer_hash
      }.wont_change "Customer.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["errors"].keys).must_include "phone"
      must_respond_with :bad_request
    end
    it "will not create a customer with nil params" do
      expect {
        post customers_path, params: nil
      }.wont_change "Customer.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["errors"].keys).must_include "name"
      expect(body["errors"].keys).must_include "address"
      expect(body["errors"].keys).must_include "registered_at"
      expect(body["errors"].keys).must_include "city"
      expect(body["errors"].keys).must_include "state"
      expect(body["errors"].keys).must_include "postal_code"
      expect(body["errors"].keys).must_include "phone"
      expect(body["errors"].keys).must_include "videos_checked_out_count"
      must_respond_with :bad_request
    end
  end
  describe "currently_checked_out" do
    it "can get route for existing customer with curren rentals, responds with :ok" do
      rentals(:rental_one)
      rentals(:rental_two)
      rentals(:rental_three)
      get customer_current_videos_path(customer1.id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 2
      must_respond_with :ok
    end
    it "gets a descriptive error if customer is not checked out to anyone, responds with :ok" do
      customer = customers(:no_rentals)
      get customer_current_videos_path(customer.id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal true
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "#{customer.name} does not currently have any checked out videos"

      must_respond_with :ok
    end
    it "responds with a 404 for nonexistent customer" do
      get customer_current_videos_path(-1)
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body["message"]).must_equal  "Customer not found"
      must_respond_with :not_found
    end
  end

  describe "checkout_history" do
    it "can get route for existing customer with a rental history, responds with :ok" do
      rental_one = rentals(:rental_one)
      rental_one.update!(due_date: Date.tomorrow, updated_at: Date.tomorrow)
      get customer_checkout_history_path(customer1.id)
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 1
      must_respond_with :ok
    end
    it "responds with a descriptive json for existing customer with no previous rentals, responds with :ok" do
      Rental.delete_all
      get customer_checkout_history_path(customer1.id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal true
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "#{customer1.name} has not previously checked out any videos"

      must_respond_with :ok
    end
    it "responds with a 404 for nonexistent customer" do
      get customer_checkout_history_path(-1)
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body["message"]).must_equal  "Customer not found"
      must_respond_with :not_found
    end
  end
end
