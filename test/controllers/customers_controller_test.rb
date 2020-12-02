
require "test_helper"

describe CustomersController do
  let(:customer) { customers(:one) }
  describe "index" do
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

    it "index works even with no customers" do
      Customer.destroy_all

      get customers_path
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0

      must_respond_with :ok
    end
  end

  # Rails scaffold generated tests below


  it "should create customer" do
    value do
      post customers_url, params: { customer: { create: @customer.create, index: @customer.index, show: @customer.show } }, as: :json
    end.must_differ "Customer.count"

    must_respond_with 201
  end

  it "should show customer" do
    get customer_url(@customer), as: :json
    must_respond_with :success
  end

  it "should update customer" do
    patch customer_url(@customer), params: { customer: { create: @customer.create, index: @customer.index, show: @customer.show } }, as: :json
    must_respond_with 200
  end

  it "should destroy customer" do
    value do
      delete customer_url(@customer), as: :json
    end.must_differ "Customer.count", -1

    must_respond_with 204
  end
end

