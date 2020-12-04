require "test_helper"

describe RentalsController do
  describe "check_out" do
    before do
      @rental_hash = {
          video: videos(:wonder_woman),
          customer: customers(:customer_one)
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
      expect(body["customer_id"]).must_equal "testtttt"
      expect(body["video_id"]).must_equal "tesssttt"
      expect(body["due_date"]).must_equal "tesssst"
      expect(body["available_inventory"]).must_equal "tessst"
      must_respond_with :ok
    end

    it "responds with a 404 when checking out a rental with non valid video" do

    end
    it "responds with a 404 when checking out a rental with non valid customer" do

    end
    it "responds with a 404 when checking out a rental with available inventory less than 1" do

    end




  end

  describe "check_in" do
    before do
      @rental_hash = {
          video: videos(:wonder_woman),
          customer: customers(:customer_one)
      }
    end

    it "can check_out a rental - increment video available inventory" do
      expect {post check_in_path, params: @rental_hash}.must_change "@rental_hash.video.available_inventory", 1
    end

    it "can check_out a rental - decrement customer checkout count" do
      expect {post check_in_path, params: @rental_hash}.must_change "@rental_hash.customer.videos_checked_out_count", -1
    end

    it "can check_in a rental - returns status ok, and expected body" do
      post check_in_path, params: @rental_hash
      body = JSON.parse(response.body)
      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal "testtttt"
      expect(body["video_id"]).must_equal "tesssttt"
      expect(body["videos_checked_out_count"]).must_equal "tesssst"
      expect(body["available_inventory"]).must_equal "tessst"
      must_respond_with :ok
    end


    it "responds with a 404 when checking in a rental with non valid video" do

    end
    it "responds with a 404 when checking in a rental with non valid customer" do

    end
    it "responds with a 404 when checking in a rental with non valid rental" do

    end
  end

end
