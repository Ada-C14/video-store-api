require "test_helper"

describe RentalsController do

  before do
    @customer = customers(:customer_one)
    @video = videos(:wonder_woman)
    @rental_hash = {
        video_id: @video.id,
        customer_id: @customer.id
    }
  end

  describe "check_out" do


    it "can check_out a rental - increments rental count" do
      expect {post check_out_path, params: @rental_hash}.must_change "Rental.count", 1
    end
    it "can check_out a rental - decrement video available inventory" do
      expect {post check_out_path, params: @rental_hash}.must_change "@video.reload.available_inventory", -1
    end

    it "can check_out a rental - increment customer checkout count" do
      count = @customer.videos_checked_out_count
      post check_out_path, params: @rental_hash
      @customer.reload
      expect(@customer.videos_checked_out_count).must_equal count + 1
    end

    it "can check_out a rental - returns status ok, and expected body" do
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)

      due_date = DateTime.parse(body["due_date"])

      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal @customer.id
      expect(body["video_id"]).must_equal @video.id
      expect(due_date).must_be_close_to(DateTime.now + 7.days, 60)
      expect(body["available_inventory"]).must_equal @video.available_inventory - 1
      must_respond_with :ok
    end

    it "responds with a not found when checking out a rental with non valid video" do
      @rental_hash[:video_id] = nil
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
    it "responds with a not found when checking out a rental with non valid customer" do
      @rental_hash[:customer_id] = nil
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
    it "responds with a not found when checking out a rental with available inventory less than 1" do
      video = Video.create
      video.available_inventory = 0
      video.save
      @rental_hash[:video_id] = video
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
  end

  describe "check_in" do

    it "can check_in a rental - increment video available inventory" do
      expect {post check_in_path, params: @rental_hash}.must_change "@video.reload.available_inventory", 1
    end

    it "can check_in a rental - decrement customer checkout count" do
      count = @customer.videos_checked_out_count
      post check_in_path, params: @rental_hash
      @customer.reload
      expect(@customer.videos_checked_out_count).must_equal count - 1
    end

    it "can check_in a rental - returns status ok, and expected body" do
      post check_in_path, params: @rental_hash
      body = JSON.parse(response.body)
      fields = ["customer_id", "video_id", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal @customer.id
      expect(body["video_id"]).must_equal @video.id
      expect(body["videos_checked_out_count"]).must_equal @customer.videos_checked_out_count - 1
      expect(body["available_inventory"]).must_equal @video.available_inventory + 1
      must_respond_with :ok
    end


    it "responds with a not found when checking in a rental with non valid video" do
      @rental_hash[:video_id] = nil
      post check_in_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
    it "responds with a not found when checking in a rental with non valid customer" do
      @rental_hash[:customer_id] = nil
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
    it "responds with a not found when checking in a rental with non valid rental" do
      @rental_hash = nil
      post check_out_path, params: @rental_hash
      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end
  end

end
