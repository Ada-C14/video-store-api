require "test_helper"

describe RentalsController do
  # it "must get create" do
  #   get rentals_create_url
  #   must_respond_with :success
  # end

  describe 'check_in' do
    let(:valid_customer) { customers(:customer_one) }
    let(:valid_video) { videos(:wonder_woman) }
    let(:valid_rental) {
      {
          customer_id: valid_customer.id,
          video_id: valid_video.id
      }
    }

    it 'can check-in a video that was checked out' do
      expect{ post check_out_path, params: valid_rental}.must_change 'Rental.count', 1
      expect{ post check_in_path, params: valid_rental}.wont_change 'Rental.count'
      must_respond_with :ok
    end

    it 'increases a video available inventory count by 1 when checked in' do
      post check_out_path(valid_rental)
      expect(valid_video.available_inventory).must_equal 98

      post check_in_path(valid_rental)
      expect(valid_video.available_inventory).must_equal 99
    end

    it 'decreases a customer videos_checked_out_count by 1 when checked in' do
      post check_out_path(valid_rental)
      expect(valid_customer.videos_checked_out_count).must_equal 4

      post check_in_path(valid_rental)
      expect(valid_customer.videos_checked_out_count).must_equal 3
    end

    it 'sends a bad_request for an invalid customer' do

    end

    it 'sends a bad_request for an invalid video' do

    end

    it 'sends a not_found status for a rental that does not exist' do

    end
  end
end
