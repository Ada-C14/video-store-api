require "test_helper"

describe Customer do

  describe "relations" do

    it "has rentals" do
      customer_one = customers(:customer_one)
      expect(customer_one).must_respond_to :rentals
      customer_one.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has videos through rentals" do
      customer_one = customers(:customer_one)
      expect(customer_one).must_respond_to :videos
      customer_one.videos.each do |video|
        expect(video).must_be_kind_of Video
      end
    end





  end

end
