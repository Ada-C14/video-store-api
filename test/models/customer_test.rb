require "test_helper"

describe Customer do
  describe 'validations' do
    before do
      @valid_customer = {
          name: "Simon Del Rosario",
          registered_at: "Wed, 23 Apr 2015 07:54:14 -0700",
          postal_code: "95007",
          phone: "(469) 734-7111",
          videos_checked_out_count:5,
          address: "1314 Elm Street",
          city: "Seattle",
          state:" WA"
      }
    end
    it 'is a success with valid model' do
      customer = Customer.new(@valid_customer)
      expect(customer.valid?).must_equal true
    end

    it 'it fails without a registered_at' do
      @valid_customer["registered_at"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:registered_at]).must_equal ["can't be blank"]
    end

    it 'it fails without a name' do
      @valid_customer["name"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it 'it fails without a  postal_code' do
      @valid_customer["postal_code"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:postal_code]).must_equal ["can't be blank"]
    end

    it 'it fails without a phone' do
      @valid_customer["phone"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end

    it 'it fails without videos_checked_out_count' do
      @valid_customer["videos_checked_out_count"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:videos_checked_out_count]).must_equal ["is not a number"]
    end

    it 'it fails without an address' do
      @valid_customer["address"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:address]).must_equal ["can't be blank"]
    end

    it 'it fails without a city' do
      @valid_customer["city"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:city]).must_equal ["can't be blank"]
    end

    it 'it fails without a state' do
      @valid_customer["state"] = nil
      customer = Customer.new(@valid_customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:state]).must_equal ["can't be blank"]
    end
  end
end

