require "test_helper"

describe Customer do
  describe 'validations' do
    before do
      @customer = {
          name: "La Croix",
          registered_at: "August 30, 2020",
          postal_code: 98104,
          phone: 1234445555,
          videos_checked_out_count: 14
      }
    end
    it 'create a valid customer' do
      customer = Customer.new(@customer)
      expect(customer.valid?).must_equal true
    end

    it 'is invalid without a name' do
      @customer["name"] = nil
      customer = Customer.new(@customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it 'is invalid without a registration date' do
      @customer["registered_at"] = nil
      customer = Customer.new(@customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:registered_at]).must_equal ["can't be blank"]
    end

    it 'is invalid without a postal code' do
      @customer["postal_code"] = nil
      customer = Customer.new(@customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:postal_code]).must_equal ["can't be blank"]
    end

    it 'is invalid without a phone number' do
      @customer["phone"] = nil
      customer = Customer.new(@customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end

    it 'is invalid without videos checkout count' do
      @customer["videos_checked_out_count"] = nil
      customer = Customer.new(@customer)

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:videos_checked_out_count]).must_equal ["can't be blank"]
    end
  end
end
