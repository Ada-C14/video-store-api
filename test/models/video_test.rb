require "test_helper"

describe Video do
  it "can be instantiated" do
    # really a sanity check

    videos.each do |video|
      expect(video.valid?).must_equal true
      expect(video.errors).must_be_empty
    end
  end

  it "will have the required fields" do
    Video.column_names.each do |field|
      expect(videos(:black_widow)).must_respond_to field
    end
  end

  describe "relations" do

  end

  describe "validations" do
    it "must contain the required fields" do
      empty_video = Video.create

      expect(empty_video.valid?).must_equal false

      [:title, :release_date, :available_inventory, :overview, :total_inventory].each do |field|
        expect(empty_video.errors[field]).must_include "can't be blank"
      end

    end
    it "must have a unique title" do
      videos(:black_widow).title = "Wonder Woman 2"

      expect(videos(:black_widow).valid?).must_equal false

      expect(videos(:black_widow).errors[:title]).must_include "has already been taken"
    end

    it "must have numerical values for total/available inventory" do
      videos.each do |video|
        video.total_inventory = "NaN"
        video.available_inventory = "NaN"

        expect(video.valid?).must_equal false

        expect(video.errors[:available_inventory]).must_include "is not a number"
        expect(video.errors[:total_inventory]).must_include "is not a number"
      end
    end

    it "must have integer values for total/available inventory" do
      videos.each do |video|
        video.total_inventory = 1.5
        video.available_inventory = 1.5

        expect(video.valid?).must_equal false

        expect(video.errors[:available_inventory]).must_include "must be an integer"
        expect(video.errors[:total_inventory]).must_include "must be an integer"
      end
    end

    it "must have a total_inventory greater than 0" do
      videos(:black_widow).total_inventory = -1
      videos(:wonder_woman).total_inventory = 0

      videos.each do |video|
        expect(video.valid?).must_equal false
        expect(video.errors[:total_inventory]).must_include "must be greater than 0"
      end
    end

    it "must have available inventory between 0 and total_inventory, inclusive" do
      [-1, videos(:black_widow).total_inventory + 1].each do |stock|
        videos(:black_widow).available_inventory = stock
        expect(videos(:black_widow).valid?).must_equal false
        if stock < 0
          expect(videos(:black_widow).errors[:available_inventory]).must_include "must be greater than or equal to 0"
        else
          expect(videos(:black_widow).errors[:available_inventory]).must_include "must be less than or equal to #{videos(:black_widow).total_inventory}"
        end
      end
    end

    it "must have a release date string carrying a valid date" do
      videos(:black_widow).release_date = "not a date"
      expect(videos(:black_widow).valid?).must_equal false

      expect(videos(:black_widow).errors[:release_date]).must_include "must be valid date"
    end
  end
end
