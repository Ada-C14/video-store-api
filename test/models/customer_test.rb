require "test_helper"

describe Customer do
  describe "validations" do
    let(:customer) {
      customer = Customer.new(
        name: "Customer Name",
        registered_at: DateTime.now,
        videos_checked_out_count: 1,
        )
    }
    it "is valid when required fields are present" do
      expect(customer.valid?).must_equal true
    end

    it "is invalid without a name" do
      customer.name = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_include "can't be blank"
    end

    it "is invalid without a registration date" do
      customer.registered_at = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:registered_at]).must_include "can't be blank"
    end

    it "is invalid if registration date is in the future" do
      customer.registered_at = DateTime.now + 1

      expect(customer.valid?).must_equal false
    end

    it "is invalid if videos checked out is nil" do
      customer.videos_checked_out_count = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:videos_checked_out_count]).must_include "can't be blank"
    end

    it "is valid with 0 or more (non-negative) videos checked out" do
      customer.videos_checked_out_count = 0

      expect(customer.valid?).must_equal true
    end

    it "is invalid with a negative videos checked out" do
      customer.videos_checked_out_count = -1

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages[:videos_checked_out_count]).must_include "must be greater than or equal to 0"
    end
  end
end