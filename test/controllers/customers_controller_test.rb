require "test_helper"

describe CustomersController do
  it "must get index" do
    # Act
    get customers_path
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal Customer.count

    # Check that each customer has the proper keys
    fields = ["id", "name", "registered_at", "postal_code", 
      "phone", "videos_checked_out_count" ].sort

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

  it 'can order customers by name given query params' do
    get '/customers?sort=name'
    must_respond_with :ok

    body = JSON.parse(response.body)

    expect(body.first["name"] < body[1]["name"]).must_equal true
  end

  it 'can order customers by registered_at given query params' do
    get '/customers?sort=registered_at'
    must_respond_with :ok

    body = JSON.parse(response.body)

    expect(body.first["registered_at"] < body[1]["registered_at"]).must_equal true
    # not a perfect test since it's only the first and second element
    # could loop through the whole body and check as above.
  end

  it 'can order customers by postal_code given query params' do
    get '/customers?sort=postal_code'
    must_respond_with :ok

    body = JSON.parse(response.body)

    expect(body.first["postal_code"] < body[1]["postal_code"]).must_equal true
  end

  it 'will sort by id if query param is not valid' do
    get '/customers?sort=invalid'
    must_respond_with :ok

    body = JSON.parse(response.body)

    expect(body.first["id"] < body[1]["id"]).must_equal true
  end
end
