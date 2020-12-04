require "test_helper"

describe RentalsController do
  before do
    @video = videos(:inception)
    @customer = customers(:customer_one)
  end

  describe "check out" do

    before do
      @rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id
      }
    end

    it "can create a valid rental when checking out and return the correct fields " do
      expect {
        post check_out_path, params: @rental_hash
      }.must_differ "Rental.count", 1

      body = JSON.parse(response.body)
      rental = Rental.first
      due_date = (rental.created_at + 7.days).strftime("%Y-%m-%d")


      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal @customer.id
      expect(body["video_id"]).must_equal @video.id
      expect(body["due_date"]).must_equal due_date
      expect(body["videos_checked_out_count"]).must_equal @customer.videos_checked_out_count + 1
      expect(body["available_inventory"]).must_equal @video.available_inventory - 1

      must_respond_with :ok
    end

    it "will respond with not_found and errors for invalid customer" do
      @rental_hash[:customer_id] = -1

      expect {
        post check_out_path, params: @rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
      must_respond_with :not_found
    end

    it "will respond with not_found and errors for invalid video" do
      @rental_hash[:video_id] = -1

      expect {
        post check_out_path, params: @rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
      must_respond_with :not_found
    end

    it "return bad request if video does not have available inventory" do
      video = videos(:inception)
      video.available_inventory = 0
      video.save!

      rental_hash = {
          customer_id: @customer.id,
          video_id: video.id
      }

      expect {
        post check_out_path, params: rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)
      p body
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "No available copies for this title"
      must_respond_with :bad_request

    end
  end

  describe "check in" do
    before do
      @rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id
      }

      post check_out_path, params: @rental_hash
    end

    it "will respond with correct values for checked in rental" do

      @customer.reload
      @video.reload

      post check_in_path, params: @rental_hash

      @customer.reload
      @video.reload

      body = JSON.parse(response.body)

      fields = ["customer_id", "video_id", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal @customer.id
      expect(body["video_id"]).must_equal @video.id
      expect(body["videos_checked_out_count"]).must_equal @customer.videos_checked_out_count
      expect(body["available_inventory"]).must_equal @video.available_inventory

      must_respond_with :ok
    end

    it "will respond with not_found and errors for invalid customer" do
      @rental_hash[:customer_id] = -1

      expect {
        post check_in_path, params: @rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
      must_respond_with :not_found
    end

    it "will respond with not_found and errors for invalid video" do
      @rental_hash[:video_id] = -1

      expect {
        post check_in_path, params: @rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
      must_respond_with :not_found
    end

  end
end
