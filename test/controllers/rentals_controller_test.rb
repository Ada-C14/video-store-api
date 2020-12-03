require "test_helper"

describe RentalsController do
  describe 'checkout' do
    before do
      @customer = customers(:customer_one)
      @video = videos(:wonder_woman)
      @rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id
      }
    end
    it 'checks out a video to a customer' do

      customer_rental_count = @customer.videos_checked_out_count
      video_avail_inventory = @video.available_inventory

      expect {
        post rentals_checkout_path, params: @rental_hash
      }.must_change "Rental.count"

      rental = Rental.find_by(customer_id: @customer.id)
      @customer.reload
      @video.reload

      expect(@customer.videos_checked_out_count).must_equal customer_rental_count + 1
      expect(@video.available_inventory).must_equal video_avail_inventory - 1
      expect(rental.due_date).must_equal (Date.today + 7).to_s

      must_respond_with :success
    end

    it 'responds with not found if the customer does not exist' do
      @rental_hash[:customer_id] = -1

      expect {
        post rentals_checkout_path, params: @rental_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "customer"
    end

    it 'responds with not found if the video does not exist' do
      @rental_hash[:video_id] = -1

      expect {
        post rentals_checkout_path, params: @rental_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "video"
    end

    it 'responds with bad request if the video does not have any available inventory' do
      @video.update(available_inventory: 0)

      expect {
        post rentals_checkout_path, params: @rental_hash
      }.wont_change "Rental.count"

      must_respond_with :bad_request

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"]).must_equal ["Insufficient inventory"]
    end
  end

  describe 'checkin' do
    before do
      customer = customers(:customer_one)
      video = videos(:black_widow)

      @check_in_info = {
          customer_id: customer.id,
          video_id: video.id
      }
    end
    it 'checks in a returned video from a customer' do

      expect {
        post rentals_checkin_path, params: @check_in_info
      }.wont_change "Rental.count"

      must_respond_with :success

      rental = rentals(:rental1)
      expect(rental.return_date).must_equal Date.today.to_s

    end

    it 'it responds with not found if the customer does not exist' do
      @check_in_info[:customer_id] = -1

      expect {
        post rentals_checkin_path, params: @check_in_info
      }.wont_change "Rental.count"

      must_respond_with :not_found

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"]).must_equal ["customer not found"]
    end

    it 'it responds with not found if the video does not exist' do
      @check_in_info[:video_id] = -1

      expect {
        post rentals_checkin_path, params: @check_in_info
      }.wont_change "Rental.count"

      must_respond_with :not_found

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"]).must_equal ["video not found"]
    end

    it 'responds with not found if a rental for a valid customer/video combo does not exist' do
      customer = customers(:customer_two)
      video = videos(:black_widow)

      no_rental_hash = {
          customer_id: customer.id,
          video_id: video.id
      }

      expect {
        post rentals_checkin_path, params: no_rental_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"]).must_equal ["rental not found"]
    end
  end
end
