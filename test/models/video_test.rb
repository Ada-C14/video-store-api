require "test_helper"

describe Video do
  describe 'validations' do
    let (:blackwidow) { videos(:black_widow) }


    it "valid with the required attributes" do
      expect(blackwidow.valid?).must_equal true
    end

    it "is invalid when fields are missing" do
      invalid_video = Video.new()

      expect(invalid_video.valid?).must_equal false
      expect(invalid_video.errors.messages).must_include :title
      expect(invalid_video.errors.messages).must_include :release_date
      expect(invalid_video.errors.messages).must_include :available_inventory
      expect(invalid_video.errors.messages).must_include :overview
      expect(invalid_video.errors.messages).must_include :total_inventory

    end

    it "requires a numeric total_inventory" do
      blackwidow.total_inventory = "three"

      expect(blackwidow.valid?).must_equal false
    end

    it "requires total_inventory to be greater than or equal to 0" do
      blackwidow.total_inventory = -3

      expect(blackwidow.valid?).must_equal false
    end


    it "requires a numeric available_inventory" do
      blackwidow.available_inventory = "three"

      expect(blackwidow.valid?).must_equal false
    end

    it "requires available_inventory to be greater than or equal to 0" do
      blackwidow.available_inventory = -3

      expect(blackwidow.valid?).must_equal false
    end
  end
end
