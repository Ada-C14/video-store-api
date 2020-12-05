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

  let (:oos_video) {
    Video.create!(
      title: 'test',
      overview: 'test',
      release_date: 'test',
      total_inventory: 1,
      available_inventory: 0
    )
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

  describe 'relationships' do

  end

  describe 'custom methods' do
    describe 'in_stock?' do
      it 'returns true if video is in-stock' do
        expect(video.in_stock?).must_equal true
      end

      it 'returns false if video is out-of-stock' do
        expect(oos_video.in_stock?).must_equal false
      end
    end

    describe 'check_in' do

    end

    describe 'check_out' do

    end
  end
end
