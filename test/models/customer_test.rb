require "test_helper"

describe Customer do
  describe "relationships" do
    it "can have many rentals" do
      customer = customers(:customer_two)
      video2 = videos(:wonder_woman)
      video = videos(:black_widow)
      rental = Rental.create(due_date: Date.today + 7,
                             customer_id: customer.id,
                             video_id: video.id,)

      rental2 = Rental.create(due_date: Date.today + 7,
                              customer_id: customer.id,
                              video_id: video2.id,)

      expect(customer.rentals.count).must_equal 2
      customer.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end
end
