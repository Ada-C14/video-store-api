require "test_helper"

describe RentalsController do
  let(:customer) { customers(:customer_one) }
  let(:video) { videos(:wonder_woman) }

  let(:rental_data) {
    {
      rental: {
        customer_id: customer.id,
        video_id: video.id,
      }
    }
  }

  describe "create/checkout" do
    it "creates a new rental" do
      expect{
        post check_out_path, params: rental_data
      }.must_change "Rental.count", 1

      must_respond_with :created
    end

    it "increase the customer's videos_checked_out_count by one" do
      expect{
        post check_out_path, params: rental_data
      }.must_change "Customer.videos_checked_out_count.count", 1
    end

    it "decrease the video's available_inventory by one" do
      expect{
        post check_out_path, params: rental_data
      }.must_change "Video.available_inventory.count", -1
    end
  end


  it "must get destroy" do
  end

end
