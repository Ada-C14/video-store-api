require "test_helper"

describe Rental do

  before do
    @rental = rentals(:rental_one)
  end

  describe "validations" do

    it 'id valid when all fields are present' do
      expect(@rental.valid?).must_equal true
    end

    it "requires a customer id" do
      @rental.customer_id = nil
      expect(@rental.valid?).must_equal false
    end

    it "requires a video id" do
      @rental.video_id = nil
      expect(@rental.valid?).must_equal false
    end
  end
end
