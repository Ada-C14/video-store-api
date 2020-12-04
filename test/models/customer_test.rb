require "test_helper"

describe Customer do
  describe "validations" do
    let (:customer) {
      Customer.new(
          name: "test_name",
          registered_at: DateTime.now,
          address: "221B Baker Street",
          city: "test_city",
          state: "test_state",
          postal_code: "123456",
          phone: "4444444444"
      )
    }

    it "is with all required fields" do
      expect(customer.valid?).must_equal true
    end

    it "has the required fields" do
      customer.save
      new_customer = Customer.first

      [:name, :registered_at, :address, :city, :state, :postal_code, :phone].each do |field|
        expect(new_customer).must_respond_to field
      end
    end

    it "is invalid without a name" do
      customer.name = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
    end

    it 'is invalid without address' do
      customer.address = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :address
    end


    it 'is invalid without registered_at' do
      customer.registered_at = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :registered_at
    end

    it 'is invalid without a city' do
      customer.city = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :city
    end

    it 'is invalid without a state' do
      customer.state = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :state
    end

    it 'is invalid without a postal_code' do
      customer.postal_code = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :postal_code
    end

    it 'is invalid without a phone' do
      customer.phone = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :phone
    end
  end



end
