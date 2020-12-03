require "test_helper"

describe Video do

  let(:video_hash) {
    {
      title: 'Alf the movie',
      overview: 'The most early 90s movie of all time',
      release_date: 'December 16th 2025',
      total_inventory: 6,
      available_inventory: 6
    }
  }

  let (:video) {
    Video.create!(video_hash)
  }

  it 'can be instantiated' do
    expect(video.valid?).must_equal true

    %w[title overview release_date total_inventory available_inventory].each do |field|
      expect(video).must_respond_to field
    end
  end

  describe 'validations' do
    it 'must have a title' do
      video.title = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
    end

    it 'must have a overview' do
      video.overview = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :overview
    end

    it 'must have a release date' do
      video.release_date = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :release_date
    end

    it 'must have a total inventory number' do
      video.total_inventory = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :total_inventory
    end

    it 'must have a total inventory number greater than or equal to 0' do
      video.total_inventory = -1

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :total_inventory
      expect(video.errors.messages[:total_inventory]).must_include 'must be greater than or equal to 0'
    end

    it 'must have an available inventory number' do
      video.available_inventory = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
    end

    it 'must have an available inventory number greater than or equal to 0' do
      video.available_inventory = -1

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include 'must be greater than or equal to 0'
    end
  end
end
