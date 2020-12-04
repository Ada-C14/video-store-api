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

    it "can check_out a rental - returns status ok, and expected body" do
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal ""
      expect(body["video_id"]).must_equal ""
      expect(body["due_date"]).must_equal ""
      expect(body["available_inventory"]).must_equal ""
      must_respond_with :ok
    end





  end

  # describe "check_in" do
  #
  # end

end
