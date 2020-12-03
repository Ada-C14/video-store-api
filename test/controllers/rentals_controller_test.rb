require "test_helper"

describe RentalsController do
  let(:customer) { customers(:customer_one) }
  let(:video) { videos(:released_movie) }

  let(:rental_data) {
      {
        customer_id: customer.id,
        video_id: video.id,
      }
    }

  describe "create/checkout" do
    it "creates a new rental" do
      post check_out_path, params: rental_data

      expect{
        post check_out_path, params: rental_data
      }.must_change "Rental.count", 1

      check_response(expected_type: Hash, expected_status: 200)
    end

    it "will respond with 404 for invalid customer" do
      rental_data[:customer_id] = nil

      expect{
        post check_out_path, params: rental_data
      }.wont_change "Rental.count"

      check_response(expected_type: Hash, expected_status: 404)
    end

    it "will respond with 404 for invalid video" do
      rental_data[:video_id] = nil

      expect{
        post check_out_path, params: rental_data
      }.wont_change "Rental.count"

      check_response(expected_type: Hash, expected_status: 404)
    end

    it "will respond with bad_request for video that is not released yet" do
      video.release_date = DateTime.now + 1
      video.save

      expect{
        post check_out_path, params: rental_data
      }.wont_change "Rental.count"

      check_response(expected_type: Hash, expected_status: 400)
    end
  end


  it "must get destroy" do
  end

end
