require "test_helper"

describe Rental do
  describe 'relationships' do
    it 'has a customer' do
      rental = rentals(:one)
      expect(rental).must_respond_to :customer
      expect(rental.customer).must_be_kind_of Customer
    end

    it 'has a video' do
      rental = rentals(:one)
      expect(rental).must_respond_to :video
      expect(rental.video).must_be_kind_of Video
    end
  end
end
