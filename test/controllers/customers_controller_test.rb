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
      "phone", "videos_checked_out_count"].sort

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

  it "sorts by ID as default" do
    # Act
    get customers_path
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal Customer.count

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["id"]).must_be :<=, last_customer["id"]

    must_respond_with :ok
  end

  it "sorts by params[sort]" do
    # Act
    get "/customers?sort=name"
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal Customer.count

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["name"]).must_be :<=, last_customer["name"]

    must_respond_with :ok
  end

  it "sorts by ID for invalid params[sort]" do
    # Act
    get "/customers?sort=test"
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal Customer.count

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["id"]).must_be :<=, last_customer["id"]

    must_respond_with :ok
  end

  it "paginates by params[p] & params[n] with sorting by ID as default" do
    # Arrange
    get customers_path
    body_default = JSON.parse(response.body)
    fourth_customer = body_default.first(4).last
    sixth_customer = body_default.first(6).last

    # Act
    get "/customers?n=3&p=2"
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal 3

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["id"]).must_be :<=, last_customer["id"]
    expect(first_customer).must_equal fourth_customer
    expect(last_customer).must_equal sixth_customer

    must_respond_with :ok
  end

  it "paginates by params[p] & params[n] and is relative to the sorted order" do
    # Arrange
    get "/customers?sort=name"
    body_default = JSON.parse(response.body)
    fourth_customer = body_default.first(4).last
    sixth_customer = body_default.first(6).last

    # Act
    get "/customers?sort=name&n=3&p=2"
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal 3

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["name"]).must_be :<=, last_customer["name"]
    expect(first_customer).must_equal fourth_customer
    expect(last_customer).must_equal sixth_customer

    must_respond_with :ok
  end

  it "sorts by ID as default with invalid pagination" do
    # Arrange
    get customers_path
    body_default = JSON.parse(response.body)
    default_first = body_default.first
    default_last = body_default.last

    # Act
    get "/customers?n=-1&p=-2"
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body.length).must_equal Customer.count

    first_customer = body.first
    last_customer = body.last
    expect(first_customer["id"]).must_be :<=, last_customer["id"]
    expect(first_customer).must_equal default_first
    expect(last_customer).must_equal default_last

    must_respond_with :ok
  end
end
