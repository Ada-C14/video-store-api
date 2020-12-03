require "test_helper"

describe Customer do
  describe "validations" do
    let (:customer_one) {customers(:customer_one)}
    it "can be created" do
      expect(customer_one.valid?).must_equal true
    end

    it "requires name address city state postal_code phone" do
      required_fields = [:name, :address, :city, :state, :postal_code, :phone]

      required_fields.each do |field|
        customer_one[field] = nil

        expect(customer_one.valid?).must_equal false

        customer_one.reload
      end
    end

    it "requires a name" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end

    it "requires an address" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end

    it "requires a city" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end

    it "requires a state" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end

    it "requires a postal_code" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end

    it "requires a phone" do
      customer_one.name = nil

      expect(customer_one.valid?).must_equal false
    end
  end
end
