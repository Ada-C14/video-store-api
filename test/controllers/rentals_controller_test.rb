require "test_helper"

describe RentalsController do

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header["Content-Type"]).must_include "json"

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "checkout" do
    before do
      @new_rental = {
          customer_id: Customer.first.id,
          video_id: Video.first.id
      }
    end

    it "returns rental information for a valid request" do
      video_count = Video.first.available_inventory
      customer_count = Customer.first.videos_checked_out_count

      expect {
        post checkout_path, params: @new_rental
      }.must_differ "Rental.count", 1

      body = check_response(expected_type: Hash)
      response_fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort

      expect(body.keys.sort).must_equal response_fields
      expect(body["customer_id"]).must_equal Customer.first.id
      expect(body["video_id"]).must_equal Video.first.id
      expect(body["due_date"]).must_equal (Date.today + 7).strftime("%Y-%m-%d")
      expect(body["videos_checked_out_count"]).must_equal customer_count + 1
      expect(body["available_inventory"]).must_equal video_count - 1
    end

    it "returns 404 for nonexistent customer or video" do
      @new_rental[:rental][:customer_id] = -1
      @new_rental[:rental][:video_id] = -1

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"].keys).must_include "customer_id"
      expect(body["errors"].keys).must_include "video_id"
    end

    it "returns bad request for video with no available inventory" do
      video = Video.first
      video.available_inventory = 0

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "age"
    end

    it "returns bad request if given no customer or video id" do
      @new_rental[:rental][:customer_id] = nil
      @new_rental[:rental][:video_id] = nil

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "customer_id"
      expect(body["errors"].keys).must_include "video_id"
    end
  end
end
