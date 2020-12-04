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

  it "will be valid with inventory equal to 0" do
    @video.available_inventory = 0
    expect(@video.valid?).must_equal true
  end

  it "will be valid with inventory less than 0" do
    @video.available_inventory =-1
    expect(@video.valid?).must_equal false
  end


  describe "checkout" do

    it "will checkout if there is enough inventory" do
      expect(@video.available_inventory).must_equal 100
      expect(@video.checkout).must_equal true
    end

    it "wont checkout if there is not enough inventory" do
      @video.available_inventory = 0
      expect(@video.checkout).must_equal false
    end
  end
end
