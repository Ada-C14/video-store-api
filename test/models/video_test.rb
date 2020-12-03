require "test_helper"

describe Video do

  before do
    @video = videos(:wonder_woman)
  end
  describe 'validations' do
    it 'id valid when all fields are present' do
      expect(@video.valid?).must_equal true
    end

    it 'will be invalid without title' do

      @video.title = nil

      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :title
      expect(@video.errors.messages[:title][0]).must_equal "can't be blank"

    end
  end
end
