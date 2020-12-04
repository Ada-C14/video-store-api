require "test_helper"

describe Video do
  describe "Validations" do
    it "is valid when all fields are filled" do
      video = videos(:wonder_woman)
      expect(video.valid?).must_equal true
    end
    it "requires a title" do
      video = Video.new(overview: "overview", release_date: "date", total_inventory: 2, available_inventory: 1)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
    end
    it "requires a title" do
      video = Video.new(overview: "overview", release_date: "date", total_inventory: 2, available_inventory: 1)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
    end
    it "requires an overview" do
      video = Video.new(title: "title", release_date: "date", total_inventory: 2, available_inventory: 1)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :overview
    end
    it "requires a release date" do
      video = Video.new(title: "title", overview: "overview", total_inventory: 2, available_inventory: 1)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :release_date
    end
    it "requires total inventory" do
      video = Video.new(title: "title", overview: "overview", release_date: "date", available_inventory: 1)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :total_inventory
    end
    it "requires available inventory" do
      video = Video.new(title: "title", overview: "overview", release_date: "date", total_inventory: 2)
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
    end
  end

  describe "Relations" do
    it "has a list of rentals" do
      video = videos(:wonder_woman)
      expect(video).must_respond_to :rentals
      video.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end
  end

  describe "decrease available inventory" do
    it "decreases available inventory count" do

    end
  end

  describe "increase available inventory" do
    
  end
end
