require "test_helper"

describe RentalsController do
  before do
    @customer = customers(:customer_one)
    @video = videos(:wonder_woman)
  end
  describe 'checkout' do
    it 'can create a new rental' do
      initial_customer_rentals = @customer.videos_checked_out_count
      initial_video_inventory = @video.available_inventory

      rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id,
      }

      expect{
        post checkout_path, params: rental_hash
      }.must_change 'Rental.count', 1

      # customer videos_checked_out should go + 1
      expect((initial_customer_rentals + 1) == @customer.reload.videos_checked_out_count).must_equal true
      # video inventory should go - 1
      expect((initial_video_inventory - 1) == @video.reload.available_inventory).must_equal true
    end
  end

  describe "check-in" do
    it "successfully checks in a video and correctly modifies customer and video data" do
      rental = Rental.create(customer_id: @customer.id, video_id: @video.id, due_date: "2020-12-9", videos_checked_out_count: @customer.videos_checked_out_count + 1, available_inventory: @video.available_inventory - 1)

      expect{
        post checkout_path(rental.id)
      }.wont_change 'Rental.count'

      expect{@customer.videos_checked_out_count}.must_change 1
    end
  end

end
