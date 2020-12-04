require "test_helper"

describe Video do

  describe "validations" do
    let(:video) {
      Video.new(
          title: "test title",
          overview: "test overview",
          release_date: Date.today - 100,
          total_inventory: 5,
          available_inventory: 3)


    }
    it "is valid with all fields" do
      expect(video.valid?).must_equal true
      expect(video.errors.messages).must_be_empty
    end

    it "must have a title" do
      video.title = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
    end

    it "must have an overview" do
      video.overview = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :overview
    end

    it "must have a release_date" do
      video.release_date = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :release_date
    end

    it "must have a total_inventory" do
      video.total_inventory = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :total_inventory
      expect(video.errors.messages[:total_inventory]).must_include "can't be blank"

    end

    it "must have a total_inventory greater than or equal to 0" do
      video.total_inventory = -1
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :total_inventory
      expect(video.errors.messages[:total_inventory]).must_include "must be greater than or equal to 0"
    end

    it "must have an available_inventory" do
      video.available_inventory = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "can't be blank"
    end

    it "must have an available_inventory greater than or equal to 0" do
      video.available_inventory = -1
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "This video is out of stock"
    end
  end

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
