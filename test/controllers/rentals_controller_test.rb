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
      expect(body["videos_checked_out_count"]).must_equal Customer.first.videos_checked_out_count
      expect(body["available_inventory"]).must_equal Video.first.available_inventory
    end

    it "returns 404 for nonexistent customer" do
      @new_rental[:customer_id] = -1

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"]).must_include "Not Found"
    end

    it "returns 404 for nonexistent video" do
      @new_rental[:video_id] = -1

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"]).must_include "Not Found"
    end

    it "returns bad request for video with no available inventory" do
      video = videos(:fury_road)
      @new_rental[:video_id] = video.id

      expect {
        post checkout_path, params: @new_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"]).must_include "Not In Stock"
    end

    it "returns bad request if given no customer id" do
      bad_rental = { video_id: Video.first.id }

      expect {
        post checkout_path, params: bad_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"]).must_include "ID Required"
    end

    it "returns bad request if given no video id" do
      bad_rental = { customer_id: Customer.first.id }

      expect {
        post checkout_path, params: bad_rental
      }.wont_change "Rental.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"]).must_include "ID Required"
    end
  end

  describe "checkin" do
    let(:rental_data) {
      {
          video_id: videos(:wonder_woman).id,
          customer_id: customers(:customer_one).id
      }
    }
    before do
      post checkout_path, params: rental_data
    end

    it "allows checkin" do
      inventory_count = videos(:wonder_woman).available_inventory
      video_count = customers(:customer_one).videos_checked_out_count

      expect {
        post checkin_path, params: rental_data
      }.must_differ "Rental.count", 0

      must_respond_with :success
      expect(Rental.all.first.checkout_date).must_equal Date.today

      video = Video.find_by(id: rental_data[:video_id])
      customer = Customer.find_by(id: rental_data[:customer_id])

      expect(video.available_inventory).must_equal inventory_count
      expect(customer.videos_checked_out_count).must_equal video_count
    end

    it "prevents check in customer has not made rental" do
      rental_data[:customer_id] = nil

      expect {
        post checkin_path, params: rental_data
      }.must_differ "Rental.count", 0

      must_respond_with :not_found
    end

    it "prevents check in if video does not exist" do
      rental_data[:video_id] = nil

      expect {
        post checkout_path, params: rental_data
      }.must_differ "Rental.count", 0

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"]).must_include "ID Required"
    end


  end
end
