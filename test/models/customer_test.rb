require "test_helper"

describe Customer do
    let (:simon) {customers(:customer_one)}
    it "can be created" do
      expect(simon.valid?).must_equal true
      expect(simon).must_be_instance_of Customer
    end

    it "requires name, registered at, address, city, state, postal code, phone, and videos checked out count" do
      required_fields = [:name, :registered_at, :address, :city, :state, :postal_code, :phone, :videos_checked_out_count]

      required_fields.each do |field|
        simon[field] = nil

        expect(simon.valid?).must_equal false
        expect(simon.errors.messages[field]).must_include "can't be blank"

        simon.reload
      end
    end

    it "requires a numeric videos checked out count" do
      simon.videos_checked_out_count = "three"

      expect(simon.valid?).must_equal false
      expect(simon.errors.messages[:videos_checked_out_count]).must_include "is not a number"
    end

    it "requires a videos checked out count greater than 0" do
      simon.videos_checked_out_count = -1

      expect(simon.valid?).must_equal false
      expect(simon.errors.messages[:videos_checked_out_count]).must_include "must be greater than or equal to 0"
    end
end
