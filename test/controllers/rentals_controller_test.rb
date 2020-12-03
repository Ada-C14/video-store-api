require "test_helper"

describe RentalsController do

  describe "check-out" do
    before do
      @rental_hash = {
          video_id: videos(:wonder_woman).id,
          customer_id: customers(:customer_one).id
      }
    end

    it "check-out works with valid params" do

      checkout_count = Customer.find_by(id: @rental_hash[:customer_id]).videos_checked_out_count
      available_inventory = Video.find_by(id: @rental_hash[:video_id]).available_inventory

      expect {
        post rentals_check_out_path, params: @rental_hash
      }.must_differ "Rental.count", 1

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["customer_id"]).must_equal @rental_hash[:customer_id]
      expect(body["video_id"]).must_equal @rental_hash[:video_id]
      expect(body["due_date"]).wont_be_nil
      expect(body["videos_checked_out_count"]).must_equal checkout_count + 1
      expect(body["available_inventory"]).must_equal available_inventory - 1


      must_respond_with :created

    end

    it "will not check out with invalid customer" do
      @rental_hash[:customer_id] = nil

      expect {
        post rentals_check_out_path, params: @rental_hash
      }.wont_change "Rental.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "customer"

      must_respond_with :bad_request

    end

    it "will not check out with invalid video" do
      @rental_hash[:customer_id] = customers(:customer_one).id
      @rental_hash[:video_id] = nil

      expect {
        post rentals_check_out_path, params: @rental_hash
      }.wont_change "Rental.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "video"

      must_respond_with :bad_request

    end
  end

  it "must get check-in" do
    skip
    get rentals_check_out_path
    must_respond_with :success
  end

end
