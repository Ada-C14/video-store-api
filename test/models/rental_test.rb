require "test_helper"

describe Rental do
  describe "validations" do
    it "is valid when customer and video is present" do
      customer = customers(:customer_one)
      video = videos(:black_widow)
      new_rental = Rental.create(customer_id: customer.id, video_id: video.id)

      expect(new_rental.valid?).must_equal true
    end

    it "is invalid when customer_id is invalid" do
      video = videos(:black_widow)
      invalid_rental = Rental.create(customer_id: -1, video_id: video.id)

      expect(invalid_rental.valid?).must_equal false
    end

    it "is invalid when video_id is invalid" do
      customer = customers(:customer_one)
      invalid_rental = Rental.create(customer_id: customer.id, video_id: -1)

      expect(invalid_rental.valid?).must_equal false
    end
  end
end
