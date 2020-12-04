require "test_helper"

describe Customer do
  describe "relations" do
    it "has a list of rentals" do
      customer = customers(:customer_one)
      expect(customer).must_respond_to :rentals
      customer.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end
  end

  describe "model methods" do
    it "increases videos checked out count" do
      customer = customers(:customer_one)
      customer.increase_videos_checked_out
      expect(customer.videos_checked_out_count).must_equal 4
    end

    it "decreases videos checked out count" do
      customer = customers(:customer_one)
      customer.decrease_videos_checked_out
      expect(customer.videos_checked_out_count).must_equal 2
    end
  end
end
