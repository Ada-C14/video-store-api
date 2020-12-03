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
    it '' do

    end
  end
end
