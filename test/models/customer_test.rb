require "test_helper"

describe Customer do
  describe "validations" do
    it "is valid when name is present" do
      customer = customers(:customer_one)

      expect(customer.valid?).must_equal true
    end

    it "is invalid when name is missing" do
      invalid_customer = Customer.new(name: nil)

      expect(invalid_customer.valid?).must_equal false
      expect(invalid_customer.errors.messages).must_include :name
    end
  end
end