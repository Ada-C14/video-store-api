require "test_helper"

describe RentalsController do
  describe "check in" do
    it "can check out if both the customer and video exist" do
      video = videos(:wonder_woman)
      customer = customers(:customer_one)
      rentals_hash = {
          video_id: video.id,
          customer_id: customer.id,
      }

      expect {
        post check_out_path, params: rentals_hash
      }.must_change "Rental.count", 1

      must_respond_with :success

      expect(video.available_inventory - video.reload.available_inventory).must_equal 1
      expect(customer.reload.videos_checked_out_count - customer.videos_checked_out_count).must_equal 1 # TODO why isn't this changing?
    end

    it "cannot check out if the customer does not exist" do
      video = videos(:wonder_woman)
      rentals_hash = {
          video_id: video.id,
          customer_id: nil
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal ["Not Found"]
      must_respond_with :not_found
    end

    it "cannot check out if the video does not exist" do
      customer = customers(:customer_one)
      rentals_hash = {
          video_id: nil,
          customer_id: customer.id
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal ["Not Found"]
      must_respond_with :not_found
    end

    it "responds with bad request and cannot check out if there is no available inventory" do
      video = videos(:wonder_woman)
      customer = customers(:customer_one)
      video.available_inventory = 0
      video.save
      rentals_hash = {
          video_id: video.id,
          customer_id: customer.id,
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal ["No Available Inventory"]
      must_respond_with :bad_request
    end
  end

  describe "check in" do
    it "can check in if both the customer and video exist" do
      video = videos(:wonder_woman)
      customer = customers(:customer_one)
      rentals_hash = {
          video_id: video.id,
          customer_id: customer.id,
      }

      post check_in_path, params: rentals_hash

      must_respond_with :success

      expect(video.reload.available_inventory - video.available_inventory).must_equal 1
      expect(customer.videos_checked_out_count - customer.reload.videos_checked_out_count).must_equal 1
    end

    it "cannot check in if the customer does not exist" do
      video = videos(:wonder_woman)
      rentals_hash = {
          video_id: video.id,
          customer_id: nil
      }

      post check_in_path, params: rentals_hash

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal ["Not Found"]
      must_respond_with :not_found
    end

    it "cannot check in if the video does not exist" do
      customer = customers(:customer_one)
      rentals_hash = {
          video_id: nil,
          customer_id: customer.id
      }

      post check_in_path, params: rentals_hash

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal ["Not Found"]
      must_respond_with :not_found
    end
  end
end