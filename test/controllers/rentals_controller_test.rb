require "test_helper"

describe RentalsController do
  before do
    @video = videos(:inception)
    @customer = customers(:customer_one)
  end
  describe "check out" do
    it "can create a valid rental when checking out" do
      rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id
      }

      expect {
        post check_out_path, params: rental_hash
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "will respond with bad request and errors for invalid customer" do
      rental_hash = {
          customer_id: -1,
          video_id: @video.id
      }

      # rental_hash[:customer] = nil

      expect {
        post check_out_path, params: rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "customer"
      must_respond_with :not_found

    end
  end

  describe "check in" do

  end
end
