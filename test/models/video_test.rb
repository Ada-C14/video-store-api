require "test_helper"

describe Video do
  describe "relations" do

    it "has rentals" do
      video_one = customers(:wonder_woman)
      expect(video_one).must_respond_to :rentals
      video_one.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

  end
end
