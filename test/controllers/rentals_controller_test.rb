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
