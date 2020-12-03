require "test_helper"

describe Customer do
  describe "validations" do
    it "validates that all fields are present" do
      customer = customers(:customer_one)

      expect(customer.valid?).must_equal true
    end

    it "must include customer's name and fails validation if it's not there" do
      customer = customers(:customer_one)
      customer.name = nil

      customer2 = Customer.find_by(name: "Becca")

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
      expect(customer2.valid?).must_equal true
    end

    it "fails validation if customer names are not unique" do
      customer = Customer.find_by(name: "Simon Del Rosario")
      customer2 = Customer.create(name: "Simon Del Rosario", registered_at: "Thur, 29 Apr 2015 07:54:14 -0700", address: "23424 weeee", city: "Lynnwood", state: "WA", postal_code: "98126", phone: "(123)423-4566", videos_checked_out_count: 3)

      expect(customer2.valid?).must_equal false
      expect(customer2.errors.messages).must_include :name
      expect(customer2.errors.messages[:name]).must_equal ["has already been taken"]
    end
  end
end
