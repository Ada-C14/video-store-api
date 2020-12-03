require "test_helper"

describe Rental do
  describe "relations" do

    it "must respond to videos" do
      rental_1 = rentals(:rental_1)
      expect(rental_1).must_respond_to :videos
      rental_1.rentals.each do |video|
        expect(video).must_be_kind_of Video
      end
    end

    it "must respond to customers" do
      rental_1 = rentals(:rental_1)
      expect(rental_1).must_respond_to :customers
      rental_1.rentals.each do |customer|
        expect(customer).must_be_kind_of Customer
      end
    end

  end

  describe "validations" do
    before do
      @rental = Rental.new(customer_id: 123, video_id: 456, checkout_date: "January 1st 2020", due_date: "January 7th, 2020")
    end

    it "must have a customer_id" do
      @rental.customer_id = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :customer_id
    end

    it "must have a video_id" do
      @rental.video_id = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :video_id
    end

    it "must have a checkout_date" do
      @rental.checkout_date = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :checkout_date
    end

    it "must have a due_date" do
      @rental.due_date = nil
      expect(@rental.valid?).must_equal false
      expect(@rental.errors.messages).must_include :due_date
    end

  end

  end
end
