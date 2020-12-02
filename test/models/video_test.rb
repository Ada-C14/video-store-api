require "test_helper"

describe Video do
  describe "validations" do
    before do
      @video = Video.new(
          title: "Mad Max: Fury Road",
          overview: "Furiosa kicks ass, takes names",
          release_date: 2015-05-15,
          total_inventory: 10,
          available_inventory: 5
      )
    end

    it "creates a movie with all appropriate fields" do
      success = @video.valid?

      expect(success).must_equal true
    end

    it "will not create a movie without a title" do
      @video.title = nil

      success = @video.valid?

      expect(success).must_equal false
    end

    it "will not create a movie without an overview" do
      @video.overview = nil

      success = @video.valid?

      expect(success).must_equal false
    end

    it "will not create a movie without a release date" do
      @video.release_date = nil

      success = @video.valid?

      expect(success).must_equal false
    end

    it "will not create a movie without a total inventory" do
      @video.total_inventory = nil

      success = @video.valid?

      expect(success).must_equal false
    end

    it "will not create a movie without an available inventory" do
      @video.available_inventory = nil

      success = @video.valid?

      expect(success).must_equal false
    end
  end
end
