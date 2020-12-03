require "test_helper"

describe RentalsController do
  let(:valid_customer) { customers(:customer_two) }
  let(:valid_video) { videos(:wonder_woman) }
  let(:valid_rental_hash) {
    {
        customer_id: valid_customer.id,
        video_id: valid_video.id
    }
  }
  describe 'check_in' do

    it 'can check-in a video that was checked out' do
      expect{ post check_out_path, params: valid_rental_hash}.must_change 'Rental.count', 1
      expect{ post check_in_path, params: valid_rental_hash}.wont_change 'Rental.count'

      must_respond_with :ok
    end

    it 'increases a video available inventory count by 1 when checked in' do
      post check_out_path(params: valid_rental_hash)
      valid_video.reload
      expect(valid_video.available_inventory).must_equal 98

      post check_in_path(params: valid_rental_hash)
      valid_video.reload
      expect(valid_video.available_inventory).must_equal 99
    end

    it 'decreases a customer videos_checked_out_count by 1 when checked in' do
      post check_out_path(params: valid_rental_hash)
      valid_video.reload
      expect(valid_customer.videos_checked_out_count).must_equal 2

      post check_in_path(params: valid_rental_hash)
      valid_video.reload
      expect(valid_customer.videos_checked_out_count).must_equal 1
    end

    it "can set the check_in date when rental is succesfully checked in" do
      new_rental = Rental.create!(
          customer_id: valid_customer.id,
          video_id: valid_video.id
          )

      pp new_rental[:check_in]
      expect(new_rental.check_in).must_be_nil
      post check_in_path(params: valid_rental_hash)
      new_rental.reload
      pp new_rental[:check_in]

      expect(new_rental.check_in).must_equal Date.today
    end

    it 'sends a bad_request for an invalid customer' do
      skip
      # optional
    end

    it 'sends a bad_request for an invalid video' do
      skip
      # optional
    end

    it 'sends a not_found status for a rental that does not exist' do
      valid_rental_hash[:video_id] = -1

      post check_in_path(params: valid_rental_hash)

      must_respond_with :not_found
      body = JSON.parse(response.body)

      # Then you can test for the json in the body of the response
      expect(body['ok']).must_equal false
      expect(body['message']).must_include ['Not Found']
    end
  end
end
