require "test_helper"

describe Rental do
  describe "relationships" do
    it "can have one customer and one video" do
      customer = customers(:customer_two)
      video = videos(:black_widow)
      rental = Rental.create(due_date: Date.today + 7,
                          customer_id: customer.id,
                          video_id: video.id,)

      expect(rental).must_be_instance_of Rental
      expect(rental.video).must_be_instance_of Video
      expect(rental.customer).must_be_instance_of Customer
    end
  end
end
