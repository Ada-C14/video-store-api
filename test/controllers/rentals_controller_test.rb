require "test_helper"

describe RentalsController do
  describe 'checkout' do
    it 'can create a new rental' do
      customer = customers(:customer_one)
      video = videos(:wonder_woman)

      initial_customer_rentals = customer.videos_checked_out_count
      initial_video_inventory = video.available_inventory

      rental_hash = {
          customer_id: customer.id,
          video_id: video.id,
      }

      expect{
        post checkout_path, params: rental_hash
      }.must_change 'Rental.count', 1

      # customer videos_checked_out should go + 1
      expect((initial_customer_rentals + 1) == customer.reload.videos_checked_out_count).must_equal true
      # video inventory should go - 1
      expect((initial_video_inventory - 1) == video.reload.available_inventory).must_equal true
    end
  end

end
