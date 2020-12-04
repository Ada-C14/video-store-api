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

    it "can create a valid rental when checking out" do
      expect {
        post check_out_path, params: @rental_hash
      }.must_differ "Rental.count", 1

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
  end

  describe "check in" do

  end
end
