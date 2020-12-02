require "test_helper"

describe Video do

  describe "validations" do

    it "video must have a title" do
      # Arrange
      video = Video.first
      video.title = nil
      # Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "video title must be unique" do
      #Arrange
      video_1 = Video.find_by(title: 'Wonder Woman 2')
      video_2 = Video.find_by(title: 'Black Widow')
      video_2.title = video_1.title
      video_2.save
      #Assert
      expect(video_2.valid?).must_equal false
      expect(video_2.errors.messages).must_include :title
      expect(video_2.errors.messages[:title]).must_equal ["has already been taken"]
    end

    it "video must have a release date" do
      #Arrange
      video = Video.first
      video.release_date = nil
      #Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :release_date
      expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end

    it "video must have an available inventory" do
      video = Video.last
      video.available_inventory = nil
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "can't be blank"
    end

    it "video's available inventory must be a number" do
      video = Video.last
      video.available_inventory = 'five'
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "is not a number"
    end

    it "video's available inventory must be a number" do
      video = Video.last
      video.available_inventory = 0
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "must be greater than 0"
    end

  end



end
