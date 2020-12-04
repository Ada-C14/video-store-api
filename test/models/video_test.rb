require "test_helper"

describe Video do
  describe "validations" do
    before do
      @video = Video.new(
          title: "Bob's Burgers: The Musical",
          overview: "A story about a middle-aged restaurateur",
          release_date: "2020-12-02",
          total_inventory: 25,
          available_inventory: 27
      )
    end

    it "is valid when all fields are present" do
      expect(@video.valid?).must_equal true
    end

    it "is invalid when fields are missing" do
      invalid_video = Video.new()

      expect(invalid_video.valid?).must_equal false
      expect(invalid_video.errors.messages).must_include :title
      expect(invalid_video.errors.messages).must_include :release_date
      expect(invalid_video.errors.messages).must_include :overview
      expect(invalid_video.errors.messages).must_include :total_inventory
      expect(invalid_video.errors.messages).must_include :available_inventory
    end

    it "is invalid when title is nil" do
      @video[:title] = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :title
      expect(@video.errors.messages[:title]).must_include "can't be blank"
    end

    it "is invalid when overview is nil" do
      @video[:overview] = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :overview
      expect(@video.errors.messages[:overview]).must_include "can't be blank"
    end

    it "is invalid when overview is nil" do
      @video[:release_date] = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :release_date
      expect(@video.errors.messages[:release_date]).must_include "can't be blank"
    end

    it "is invalid when total_inventory is nil" do
      @video[:total_inventory] = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :total_inventory
      expect(@video.errors.messages[:total_inventory]).must_include "can't be blank"
    end

    it "is invalid when available_inventory is nil" do
      @video[:available_inventory] = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :available_inventory
      expect(@video.errors.messages[:available_inventory]).must_include "can't be blank"
    end
  end
end
