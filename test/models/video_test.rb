require "test_helper"

describe Video do
  describe 'validations' do
    before do
      @video = {
          title: "Ada C14",
          release_date: "August 30, 2020",
          available_inventory: 52
      }
    end
    it 'create a valid video' do
      video = Video.new(@video)
      expect(video.valid?).must_equal true
    end

    it 'is invalid without a title' do
      @video["title"] = nil
      video = Video.new(@video)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it 'is invalid without a release date' do
      @video["release_date"] = nil
      video = Video.new(@video)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end

    it 'is invalid without available inventory' do
      @video["available_inventory"] = nil
      video = Video.new(@video)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:available_inventory]).must_equal ["can't be blank"]
    end

    it 'is invalid if inventory is negative' do # Not sure if i wrote this correctly, ill come back to it.
      @video["available_inventory"] = -1
      video = Video.new(@video)

      expect(video.valid?).must_equal false
      expect(video.errors.messages[:available_inventory]).must_equal ["inventory cannot be less than 0"]
    end

  end
end
