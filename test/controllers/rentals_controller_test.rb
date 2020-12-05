require 'test_helper'

describe RentalsController do

  let (:rental_hash) {
    {
      customer_id: Customer.first.id,
      video_id: Video.first.id
    }
  }

  let (:inv_cust_rental_hash) {
    {
      customer_id: -1,
      video_id: Video.first.id
    }
  }

  let (:inv_vid_rental_hash) {
    {
      customer_id: Customer.first.id,
      video_id: -1
    }
  }

  let (:rental_checked_in) {
    Rental.create!(
      customer_id: Customer.first.id,
      video_id: Video.first.id,
      checked_out: Date.today - 7,
      due_date: Date.today,
      checked_in: Date.today - 3
    )
  }

  # let (:oos_video) {
  #   Video.create!(
  #     title: 'Alf the movie',
  #     overview: 'The most early 90s movie of all time',
  #     release_date: 'December 16th 2025',
  #     total_inventory: 6,
  #     available_inventory: 0
  #   )
  # }

  describe 'check_out_rental' do
    it 'responds with a 404 when passed an id for a non-existent video' do
      post '/rentals/check-out', params: inv_vid_rental_hash

      body = JSON.parse(response.body)
      expect(body.keys).must_include 'errors'
      expect(body['errors']).must_include 'Not Found'
      must_respond_with :not_found
    end

    it 'responds with a 404 when passed an id for a non-existent customer' do
      post '/rentals/check-out', params: inv_cust_rental_hash

      body = JSON.parse(response.body)
      expect(body.keys).must_include 'errors'
      expect(body['errors']).must_include 'Not Found'
      must_respond_with :not_found
    end

    it 'renders json error when trying to rent a video that is has no available stock' do
      video = Video.first
      video.available_inventory = 0
      video.save

      post '/rentals/check-out', params: rental_hash

      body = JSON.parse(response.body)
      expect(body.keys).must_include 'code'
      expect(body['code']).must_equal 3000
      expect(body.keys).must_include 'message'
      expect(body['message']).must_equal 'Video does not have available stock'
    end

    it 'can successfully create a rental which responds to appropriate fields' do
      post '/rentals/check-out', params: rental_hash
      body = JSON.parse(response.body)

      %w[customer_id video_id due_date available_inventory videos_checked_out_count].each do |key|
        expect(body.keys).must_include key
      end

      rental = Rental.last
      expect(body['customer_id']).must_equal rental.customer_id
      expect(body['video_id']).must_equal rental.video_id
      expect(body['due_date']).must_equal rental.due_date
      expect(body['available_inventory']).must_equal rental.video.available_inventory
      expect(body['videos_checked_out_count']).must_equal rental.customer.videos_checked_out_count
      must_respond_with :ok
    end
  end

  describe 'check_in_rental' do
    it 'responds with a 404 when rental does not exist' do
      rental_checked_in
      post '/rentals/check-in', params: inv_cust_rental_hash

      body = JSON.parse(response.body)
      expect(body.keys).must_include 'errors'
      expect(body['errors']).must_include 'Not Found'
      must_respond_with :not_found
    end
  end
end
