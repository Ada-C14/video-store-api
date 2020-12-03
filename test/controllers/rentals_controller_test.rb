require "test_helper"

describe RentalsController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "check out" do
    let(:rental){
      {video_id: videos(:black_widow).id,
       customer_id: customers(:customer_one).id}
    }

    it "can create a rental check out" do
      inventory = videos(:black_widow).available_inventory
      customer_check_out = customers(:customer_one).videos_checked_out_count

      expect {
        post check_out_path, params: rental
      }.must_differ "Rental.count", 1

      must_respond_with :success

      video = Video.find_by(id: rental[:video_id])
      customer = Customer.find_by(id: rental[:customer_id])

      expect(video.available_inventory).must_equal inventory - 1
      expect(customer.videos_checked_out_count).must_equal customer_check_out + 1
    end

    it "will not create a check out if customer doesn't exist" do
      rental[:customer_id] = nil

      expect {
        post check_out_path, params: rental
      }.must_differ "Rental.count", 0

      must_respond_with :not_found
    end

    it "will not create a check out if video doesn't exist" do
      rental[:video_id] = nil

      expect {
        post check_out_path, params: rental
      }.must_differ "Rental.count", 0

      must_respond_with :not_found
    end

  end

  describe "check in" do
    let(:rental){
      {video_id: videos(:black_widow).id,
       customer_id: customers(:customer_one).id,
       returned: false}
    }

    before do
      post check_in_path, params: rental
    end

    it "can create a rental check in" do
      inventory = videos(:black_widow).available_inventory
      customer_check_out = customers(:customer_one).videos_checked_out_count

      must_respond_with :success

      video = Video.find_by(id: rental[:video_id])
      customer = Customer.find_by(id: rental[:customer_id])

      expect(video.available_inventory).must_equal inventory + 1
      expect(customer.videos_checked_out_count).must_equal customer_check_out - 1
    end
  end
end
