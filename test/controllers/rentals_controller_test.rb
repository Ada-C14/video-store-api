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
    let(:new_rental) {
      {
          rental: {
              customer_id: Customer.first.id,
              video_id: Video.first.id
          }
      }
    }

    it "returns rental information for a valid request" do
      expect {
        post checkout_path, params: new_rental
      }.must_differ "Rental.count", 1

      body = check_response(expected_type: Hash)
      response_fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort

      expect(body.keys.sort).must_equal response_fields
    end

    it "returns 404 for nonexistent customer or video" do
      new_rental[:rental][:customer_id] = -1
      new_rental[:rental][:video_id] = -1

      expect {
        post checkout_path, params: new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"].keys).must_include "customer_id"
      expect(body["errors"].keys).must_include "video_id"
    end

    it "returns bad request for video with no available inventory" do
      video = Video.first
      video.available_inventory = 0

      expect {
        post checkout_path, params: new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "age"
    end

    it "returns bad request if given no customer or video id" do
      new_rental[:rental][:customer_id] = nil
      new_rental[:rental][:video_id] = nil

      expect {
        post checkout_path, params: new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "customer_id"
      expect(body["errors"].keys).must_include "video_id"
    end
  end
end
