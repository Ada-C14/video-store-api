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

end
