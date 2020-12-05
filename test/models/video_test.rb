require "test_helper"

describe Video do

  it "can be instantiated" do
    #arrange
    video = Video.new(
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: "December 16th 2025",
        total_inventory: 6,
        available_inventory: 6)
    video.save
    expect(Video.last).must_equal video
  end

  describe "validations" do
    before do
      @video = Video.new(title: "test video", overview: "Great movie", release_date: "June 16th 2025", total_inventory: 6, available_inventory: 6)
    end

    it "is valid when filled all fields" do
      video = Video.new(title: "test video", overview: "Great movie", release_date: "June 16th 2025", total_inventory: 6, available_inventory: 6)
      expect(video.valid?).must_equal true
    end

    it "requires a title" do
      @video.title = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :title
      expect(@video.errors.messages[:title].include?("can't be blank")).must_equal true
    end

    it "requires an overview" do
      @video.overview = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :overview
      expect(@video.errors.messages[:overview].include?("can't be blank")).must_equal true
    end

    it "requires an release date" do
      @video.release_date = nil
      expect(@video.valid?).must_equal false
      # expect(video.errors.messages).must_include :release_date
      expect(@video.errors.messages[:release_date].include?("can't be blank")).must_equal true
    end

    it "requires a total_inventory" do
      @video.total_inventory= nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :total_inventory
      expect(@video.errors.messages[:total_inventory].include?("is not a number")).must_equal true

    end

    it "requires an available_inventory" do
      @video.available_inventory = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :available_inventory
      expect(@video.errors.messages[:available_inventory].include?("is not a number")).must_equal true
    end
  end
end
