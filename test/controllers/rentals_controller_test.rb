require "test_helper"

describe RentalsController do
  def check_response(expected_type:, expected_status: :ok)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  before do
    @customer = customers(:customer_one)
    @video = videos(:wonder_woman)

    @request_body = {
        customer_id: @customer.id,
        video_id: @video.id
    }
  end

  describe "check_out" do
    it "can check out a video to a customer" do
      expect {
        post checkout_path, params: @request_body
      }.must_change "Rental.count", 1

      body = check_response(expected_type: Hash)

      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
    end

    it "cannot check out a video if the customer does not exist and returns not found" do
      @request_body[:customer_id] = nil

      expect {
        post checkout_path, params: @request_body
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "cannot check out a video if the video does not exist and returns not found" do
      @request_body[:video_id] = nil

      expect {
        post checkout_path, params: @request_body
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "cannot check out a video if the video does not have any available inventory and returns bad request" do
      @video.available_inventory = 0
      @video.save!

      expect {
        post checkout_path, params: @request_body
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_include "errors"
    end
  end

  describe "check_in" do
    it "can check in a video for a customer" do
      post checkout_path, params: @request_body

      expect {
        post checkin_path, params: @request_body
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash)

      fields = ["customer_id", "video_id", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
    end

    it "cannot check in a video if rental for that video does not exist" do
      post checkin_path, params: @request_body

      body = check_response(expected_type: Hash, expected_status: :not_found)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "cannot check out a video if the customer does not exist and returns not found" do
      post checkout_path, params: @request_body
      @request_body[:customer_id] = nil

      post checkin_path, params: @request_body

      body = check_response(expected_type: Hash, expected_status: :not_found)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "cannot check out a video if the video does not exist and returns not found" do
      post checkout_path, params: @request_body
      @request_body[:video_id] = nil

      post checkin_path, params: @request_body

      body = check_response(expected_type: Hash, expected_status: :not_found)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end

    it "cannot check in a video if the customer has no videos checked out and returns bad request" do
      post checkout_path, params: @request_body
      @customer.videos_checked_out_count = 0
      @customer.save!

      post checkin_path, params: @request_body

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_include "errors"
    end
  end
end
