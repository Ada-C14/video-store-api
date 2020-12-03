require "test_helper"

describe RentalsController do
    before do
      @rental_hash = {
          video_id: videos(:wonder_woman).id,
          customer_id: customers(:customer_one).id
      }
    end

  describe "check-out" do

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


      must_respond_with :ok

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

      must_respond_with :not_found

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

      must_respond_with :not_found

    end

    it "will not check out if available video inventory is < 1" do
      @rental_hash[:video_id] = videos(:out_of_stock).id

      expect {
        post rentals_check_out_path, params: @rental_hash
      }.wont_change "Rental.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "Not enough available inventory"

      must_respond_with :bad_request

    end
  end

  describe "check-in" do
    it "will successfully check in an existing checkout" do

      post rentals_check_out_path, params: @rental_hash

      checkout_count = Customer.find_by(id: @rental_hash[:customer_id]).videos_checked_out_count
      available_inventory = Video.find_by(id: @rental_hash[:video_id]).available_inventory

      expect {
        post rentals_check_in_path, params: @rental_hash
      }.wont_change "Rental.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      expect(body["customer_id"]).must_equal @rental_hash[:customer_id]
      expect(body["video_id"]).must_equal @rental_hash[:video_id]
      expect(body["videos_checked_out_count"]).must_equal checkout_count - 1
      expect(body["available_inventory"]).must_equal available_inventory + 1

    end

    it "will not check in with invalid video_id" do
      post rentals_check_out_path, params: @rental_hash

      @rental_hash[:video_id] = nil

      post rentals_check_in_path, params: @rental_hash

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "Invalid rental"

      must_respond_with :not_found

    end

    it "will not check in with invalid customer_id" do

      post rentals_check_out_path, params: @rental_hash

      @rental_hash[:customer_id] = nil

      post rentals_check_in_path, params: @rental_hash

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "Invalid rental"

      must_respond_with :not_found

    end

    it "will not check in a video that was not checked out by a customer" do

      post rentals_check_out_path, params: @rental_hash

      @rental_hash[:customer_id] = customers(:customer_two).id
      @rental_hash[:video_id] = videos(:black_widow).id

      post rentals_check_in_path, params: @rental_hash

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body['errors']).must_include "Invalid rental"

      must_respond_with :not_found

    end


    it "will not check in an previous rental (same customer/video)" do
      Rental.delete_all
      @rental_hash[:due_date] = Date.today + 7.days
      post rentals_check_out_path, params: @rental_hash
      post rentals_check_out_path, params: @rental_hash
      rentals = Rental.where(customer_id: @rental_hash[:customer_id], video_id: @rental_hash[:video_id])

      expect {
        post rentals_check_in_path, params: @rental_hash
      }.wont_change "Rental.count"

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["id"]).wont_equal rentals[0].id
      expect(body["id"]).must_equal rentals[1].id
      expect(body["customer_id"]).must_equal rentals[1].customer_id
      expect(body["video_id"]).must_equal rentals[1].video_id

      must_respond_with :ok
    end
  end

  describe "overdue" do
    it "returns a list of overdue rentals and responds with :ok" do

    end
    it "returns an empty array if there are no overdue rentals and responds with :ok" do

    end
  end
end
