require "test_helper"

describe Customer do
  describe 'relationships' do
    it 'has many rentals' do
      simon = customers(:customer_one)
      expect(simon).must_respond_to :rentals
      simon.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end
  end
end
