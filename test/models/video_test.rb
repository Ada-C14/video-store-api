require "test_helper"

describe Video do
  describe 'relationships' do
    it 'has many rentals' do
      video = videos(:black_widow)
      expect(video).must_respond_to :rentals
      video.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end
  end
end
