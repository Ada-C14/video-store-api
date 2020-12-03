require "test_helper"

describe Customer do
  let (:customer_one) { customers(:customer_one) }
  let (:customer_hash) do
    {
        name: "Sophie",
        registered_at: 2020-4-4,
        address: "111 S fake st",
        city: "Seattle",
        state: "WA",
        phone: "206-666-7777",
        postal_code: "99999",
        videos_checked_out_count: 8
    }
  end

  describe "relationships" do
    it "has many rentals" do
      rentals = customer_one.rentals
      expect(rentals.length).must_equal 2
      rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      customer_hash[:name] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(phone: customer_hash[:phone])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :name
    end

    it "must have a registered_at" do
      customer_hash[:registered_at] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :registered_at
    end

    it "must have address" do
      customer_hash[:address] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :address
    end

    it "must have city" do
      customer_hash[:city] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :city
    end

    it "must have state" do
      customer_hash[:state] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :state
    end

    it "must have phone" do
      customer_hash[:phone] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :phone
    end

    it "must have postal_code" do
      customer_hash[:postal_code] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :postal_code
    end

    it "must have videos_checked_out_count" do
      customer_hash[:videos_checked_out_count] = nil
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :videos_checked_out_count
    end

    it "videos_checked_out_count must be greater than or equal to 0" do
      customer_hash[:videos_checked_out_count] = -1
      customer = Customer.create(customer_hash)

      found_customer = Customer.find_by(name: customer_hash[:name])
      expect(found_customer).must_be_nil
      expect(customer.valid?).must_equal false
      expect(customer.errors.keys).must_include :videos_checked_out_count
    end

  end

  describe "custom methods" do
    describe "increment checkout_count" do
      it "increments checkout count for existing customer" do
        before_checkout = customer_one.videos_checked_out_count
        customer_one.increment_checkout_count
        expect(customer_one.videos_checked_out_count).must_equal before_checkout + 1
      end

      it "NoMethodError raised for call on nil customer" do
        customer_one = nil

        expect {
          customer_one.increment_checkout_count
        }.must_raise NoMethodError
      end
    end

    describe "decrement checkout_count" do
      it "decrements checkout count for existing customer checking in" do
        before_checkin = customer_one.videos_checked_out_count
        customer_one.decrement_checkout_count
        expect(customer_one.videos_checked_out_count).must_equal before_checkin - 1
      end

      it "NoMethodError raised for call on nil customer" do
        customer_one = nil

        expect {
          customer_one.decrement_checkout_count
        }.must_raise NoMethodError
      end
    end
  end
end