require "test_helper"

describe RentalsController do
  describe "check-out" do
    before do
      @rental_hash = {
          customer_id: customers(:customer_one).id,
          video_id: videos(:black_widow).id
      }
      @old_videos_count = customers(:customer_one).videos_checked_out_count
      @old_avail_video = videos(:black_widow).available_inventory
    end
    it "successfully checks out a valid video to a valid customer and returns a json of the new rental" do
      expect {
        post check_out_path, params: @rental_hash
      }.must_change "Rental.count", 1

      rental_cust = Customer.find_by_id(@rental_hash[:customer_id])
      rental_video = Video.find_by_id(@rental_hash[:video_id])

      expect(@old_videos_count + 1).must_equal rental_cust.videos_checked_out_count
      expect(@old_avail_video - 1).must_equal rental_video.available_inventory
      must_respond_with :success

    end

    it "returns a json with errors + 404 response if customer or video invalid" do
      [:customer_id, :video_id].each do |bad_field|
        @rental_hash[bad_field] = -1

        expect {
          post check_out_path, params: @rental_hash
        }.wont_change "Rental.count"

        body = JSON.parse(response.body)

        expect(body.keys).must_include "errors"
        expect(body["errors"]).must_include  "Not Found"
      end
    end
    it "returns a json with errors + bad_request if video doesn't have any available copies" do
      # set available_inventory of @rental_hash movie to 0
      Video.where(id: videos(:black_widow)).update(available_inventory: 0)

      expect{
        post check_out_path, params: @rental_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      rental_cust = Customer.find_by_id(@rental_hash[:customer_id])
      rental_video = Video.find_by_id(@rental_hash[:video_id])

      expect(rental_video.available_inventory).must_equal 0
      expect(rental_cust.videos_checked_out_count).must_equal @old_videos_count
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "No copies of #{videos(:black_widow).title} available"
    end
  end


  describe 'check_in' do
    let(:valid_customer) { customers(:customer_two) }
    let(:valid_video) { videos(:wonder_woman) }
    let(:valid_rental_hash) {
      {
          customer_id: valid_customer.id,
          video_id: valid_video.id
      }
    }

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
      valid_customer.reload
      expect(valid_customer.videos_checked_out_count).must_equal 3

      post check_in_path(params: valid_rental_hash)
      valid_customer.reload
      expect(valid_customer.videos_checked_out_count).must_equal 2
    end

    it "can set the check_in date when rental is succesfully checked in" do
      skip
      # optional
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
      skip
      # optional
    end
  end
end
