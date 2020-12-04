require "test_helper"

describe RentalsController do
  describe "check_out" do
    before do
      @rental_hash = {
          videos: videos(:wonder_woman),
          customers: customer(:customer_one)
      }
    end

    it "can check_out a rental - increments rental count" do
      expect {post check_out_path, params: @rental_hash}.must_change "Rental.count", 1
    end
    it "can check_out a rental - decrement video available inventory" do
      expect {post check_out_path, params: @rental_hash}.must_change "@rental_hash.video.available_inventory", -1
    end

    it "can check_out a rental - increment customer checkout count" do
      expect {post check_out_path, params: @rental_hash}.must_change "@rental_hash.customer.videos_checked_out_count", 1
    end




  end

  # describe "check_in" do
  #
  # end

end
