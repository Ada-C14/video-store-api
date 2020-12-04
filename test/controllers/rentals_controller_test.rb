require "test_helper"

describe RentalsController do
  describe "check-out" do
    it "must create new rental with checkout" do
      customer = customers(:customer_one)
      video = videos(:wonder_woman)
      rentals_hash = {
          customer_id: customer.id,
          video_id: video.id
      }

      expect {
        post check_out_path, params: rentals_hash
      }.must_change "Rental.count", 1

      must_respond_with :ok
    end

    it "will respond with not_found if customer doesn't exist" do
      video = videos(:wonder_woman)
      rentals_hash = {
          customer_id: nil,
          video_id: video.id
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "will respond with not_found if video doesn't exist" do
      customer = customers(:customer_one)
      rentals_hash = {
          customer_id: customer.id,
          video_id: nil
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "will respond with bad_request if unavailable inventory" do
      video = videos(:no_inventory)
      customer = customers(:customer_one)
      rentals_hash = {
          customer_id: customer.id,
          video_id: video.id
      }

      expect {
        post check_out_path, params: rentals_hash
      }.wont_change "Rental.count"

      must_respond_with :bad_request

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Bad Request"
    end
  end
end
