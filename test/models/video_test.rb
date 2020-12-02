require "test_helper"

describe Video do
  describe 'validations' do
    before do
      @video_info = {
          title: "Test Title",
          overview: "Test synopsis",
          release_date: "2000-01-01",
          total_inventory: 10,
          available_inventory: 10
      }
    end
    it 'is valid with the required attributes' do
      video = Video.new(@video_info)
      expect(video.valid?).must_equal true
    end

    it 'it invalid without a title' do
      @video_info["title"] = nil
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it 'is invalid without an overview' do
      @video_info["overview"] = nil
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:overview]).must_equal ["can't be blank"]
    end

    it 'is invalid without a release date' do
      @video_info["release_date"] = nil
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end

    it 'is invalid without an available inventory number' do
      @video_info["available_inventory"] = nil
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:available_inventory]).must_equal ["is not a number"]
    end

    it 'is invalid if total inventory is negative' do
      @video_info["total_inventory"] = -1
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:total_inventory]).must_equal ["must be greater than or equal to 0"]
    end

    it 'is invalid if available inventory is negative' do
      @video_info["available_inventory"] = -1
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:available_inventory]).must_equal ["must be greater than or equal to 0"]
    end

    it 'is invalid if available inventory exceeds total inventory' do
      @video_info["available_inventory"] = 11
      video = Video.new(@video_info)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:available_inventory]).must_equal ["must be less than or equal to 10"]
    end
  end
end
