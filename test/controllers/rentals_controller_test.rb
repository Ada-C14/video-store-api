require "test_helper"

describe RentalsController do

  before do
    @simon = customers(:customer_one)
    @wonder_woman = videos(:wonder_woman)
  end

  let(:bad_customer_id){
    -99999
  }

  let(:bad_video_id){
    -99999
  }

  describe "checkout" do
    it "can checkout" do
      checkout_params = {
        customer_id: @simon.id,
        video_id: @wonder_woman.id
      }

      expect(@simon.videos_checked_out_count).must_equal 3
      expect(@wonder_woman.available_inventory).must_equal 100
      
      expect {post checkout_path, params: checkout_params}.must_differ "Rental.count", 1
      
      body = check_response(expected_type: Hash, expected_status: :ok)
      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal @simon.id
      expect(body["video_id"]).must_equal @wonder_woman.id
      expect(body["due_date"]).must_equal (Time.now + 7.days).strftime("%Y-%m-%d")
      expect(body["videos_checked_out_count"]).must_equal 4
      expect(body["available_inventory"]).must_equal 99
    end

    it "returns back detailed errors and a status 404: Not Found if the customer does not exist" do
      checkout_params = {
        customer_id: bad_customer_id,
        video_id: @wonder_woman.id
      }
      expect {post checkout_path, params: checkout_params}.wont_change "Rental.count"
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"]).must_include "Not Found"
    end

    it "returns back detailed errors and a status 404: Not Found if the video does not exist" do
      checkout_params = {
        customer_id: @simon.id,
        video_id: bad_video_id
      }
      expect {post checkout_path, params: checkout_params}.wont_change "Rental.count"
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body["errors"]).must_include "Not Found"
    end

    it "returns back detailed errors and a status 400: Bad Request if the video does not have any available inventory before check out" do
      @wonder_woman.available_inventory = 0
      @wonder_woman.save

      checkout_params = {
        customer_id: @simon.id,
        video_id: @wonder_woman.id
      }
      expect(@wonder_woman.available_inventory).must_equal 0

      expect {post checkout_path, params: checkout_params}.wont_change "Rental.count"
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "available_inventory"
    end

  end

  describe 'checkin' do

    before do
      @checkout_params = {
          customer_id: @simon.id,
          video_id: @wonder_woman.id
      }

    end

    it 'can checkin' do
      expect {post checkout_path, params: @checkout_params}.must_differ "Rental.count", 1
      must_respond_with :success

      before_count_vid = @simon.reload.videos_checked_out_count
      before_count_inv = @wonder_woman.reload.available_inventory

      deleted_rental_id = Rental.find_by(customer_id: @checkout_params[:customer_id], video_id: @checkout_params[:video_id]).id

      expect {post checkin_path, params: @checkout_params}.must_differ "Rental.count", -1

      assert_nil(Rental.find_by(id: deleted_rental_id ))

      body = check_response(expected_type: Hash, expected_status: :ok)

      expect(body["customer_id"]).must_equal @simon.id
      expect(body["video_id"]).must_equal @wonder_woman.id
      expect(body["videos_checked_out_count"]).must_equal before_count_vid - 1
      expect(body["available_inventory"]).must_equal before_count_inv + 1

    end
  end
end