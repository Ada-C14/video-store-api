require "test_helper"

describe Customer do
  describe "validations" do
    it "validates that all fields are present" do
      customer = customers(:customer_one)

      expect(customer.valid?).must_equal true
    end

    it "must include customer's name" do
      customer = customers(:customer_one)
      customer.name = nil
      customer2 = customers(:customer_two)


      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer2.valid?).must_equal true #does this really work?
    end
  end
end
