require "test_helper"

describe Video do
  before do
  @video = videos(:wonder_woman) #from fixtures

  end
  describe 'validations' do
    it 'is valid when all fields are inputted correctly' do
      expect(@video.valid?).must_equal true
    end

    it "fails validation when there is no title" do
      @video.title = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages.include?(:title)).must_equal true
      expect(@video.errors.messages[:title].include?("can't be blank")).must_equal true
    end

    it "fails validation when there is no overview" do
      @video.overview = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages.include?(:overview)).must_equal true
      expect(@video.errors.messages[:overview].include?("can't be blank")).must_equal true
    end

    it "fails validation when there is no overview" do
      @video.release_date = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages.include?(:release_date)).must_equal true
      expect(@video.errors.messages[:release_date].include?("can't be blank")).must_equal true
    end

    it "fails validation when total inventory is invalid" do
      @video.total_inventory = -5
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages.include?(:total_inventory)).must_equal true
      expect(@video.errors.messages[:total_inventory].include?("must be greater than -1")).must_equal true
    end

    it "fails validation when available inventory is invalid" do
      @video.available_inventory = -2
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages.include?(:available_inventory)).must_equal true
      expect(@video.errors.messages[:available_inventory].include?("must be greater than -1")).must_equal true
    end


  end
end
