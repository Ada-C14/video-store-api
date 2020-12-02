require "test_helper"

describe Video do
  describe "validations" do
    it "is valid when all fields are present" do
      video = videos(:wonder_woman)

      expect(video.valid?).must_equal true
    end

    it "is invalid when fields are missing" do
      invalid_video = Video.new()

      expect(invalid_video.valid?).must_equal false
      expect(invalid_video.errors.messages).must_include :title
      expect(invalid_video.errors.messages).must_include :release_date
      expect(invalid_video.errors.messages).must_include :overview
      expect(invalid_video.errors.messages).must_include :total_inventory
      expect(invalid_video.errors.messages).must_include :available_inventory
    end
  end
end
