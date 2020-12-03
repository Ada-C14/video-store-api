require "test_helper"

describe RentalsController do
  before do
    @video = videos(:inception)
    @customer = customers(:customer_one)
  end
  describe "check out" do
    it "can create a valid rental when checking out" do
      rental_hash = {
          customer: @customer,
          video: @video,
          due_date: Time.now + 7.days
      }

      expect {
        post check_out_path, params: rental_hash
      }.must_differ "Rental.count", 1

      must_respond_with :created
    end

    it "will respond with bad request and errors for invalid params" do
      rental_hash = {
          customer: @customer,
          video: @video,
          due_date: Time.now + 7.days
      }

      rental_hash[:customer] = nil

      expect {
        post check_out_path, params: rental_hash
      }.wont_differ "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "customer"
      must_respond_with :bad_request

    end
  end

  describe "check in" do

  end
end
