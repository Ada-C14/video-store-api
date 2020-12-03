require "test_helper"

describe Rental do
  describe "relationships" do
    it "can have one customer and one video" do
      customer = customers(:customer_two)
      video = videos(:black_widow)
      rental = Rental.new(due_date: Date.today + 7,
                          customer_id: customer.id,
                          video_id: video.id,
                          videos_checked_out_count: customer.videos_checked_out_count,
                          available_inventory: video.available_inventory)

      expect(rental.video).must_be_instance_of Video
      expect(rental.customer).must_be_instance_of Customer
    end
  end
end
