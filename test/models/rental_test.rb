require "test_helper"

describe Rental do
  describe "validations" do
    it "is valid when customer and video is present" do
      video = videos(:black_widow)
      customer = customers(:customer_one)
      new_rental = Rental.create(customer_id: customer.id, video_id: video.id)

      expect(new_rental.valid?).must_equal true
    end

    it "is invalid when customer_id is nil" do
      video = videos(:black_widow)
      invalid_rental = Rental.create(customer_id: nil, video_id: video.id)

      expect(invalid_rental.valid?).must_equal false
    end

    it "is invalid when video_id is nil" do
      customer = customers(:customer_one)
      invalid_rental = Rental.create(customer_id: customer.id, video_id: nil)

      expect(invalid_rental.valid?).must_equal false
    end
  end
end
