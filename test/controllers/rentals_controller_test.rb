require "test_helper"

describe RentalsController do
  describe 'checkout' do
    it 'can create a new rental' do
      customer = customers(:customer_one)
      video = videos(:wonder_woman)

      expect{post checkout_path()}.must_change 'Rental.count', 1

      # customer videos_checked_out should go + 1
      # video inventory should go - 1
    end
  end

end
