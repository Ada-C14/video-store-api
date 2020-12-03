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

    it "increase the customer's videos_checked_out_count by one" do
      videos_checked_out_before = customer.videos_checked_out_count

      post check_out_path, params: rental_data

      customer.reload

      expect(customer.videos_checked_out_count).must_equal videos_checked_out_before + 1
    end

    it "decrease the video's available_inventory by one" do
      inventory_before = video.available_inventory

      post check_out_path, params: rental_data

      video.reload

      expect(video.available_inventory).must_equal inventory_before - 1
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
