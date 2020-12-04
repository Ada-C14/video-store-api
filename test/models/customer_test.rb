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

  describe "custom methods" do
    it "can decrease the video_checked_out_count" do
      customer = customers(:customer_one)
      videos_checked_out = customer.videos_checked_out_count

      expect(customer.decrease_video_checked_out_count).must_equal videos_checked_out - 1
    end

    it "can increase the video_checked_out_count" do
      customer = customers(:customer_one)
      videos_checked_out = customer.videos_checked_out_count

      expect(customer.increase_video_checked_out_count).must_equal videos_checked_out + 1
    end
  end
end