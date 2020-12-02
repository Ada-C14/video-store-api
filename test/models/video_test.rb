require "test_helper"

describe Video do
  describe Video do
    describe "validations" do
      let(:video) {
        video = Video.new(
            title: "Video Name",
            overview: 'A great video',
            release_date: DateTime.now,
            available_inventory: 1,
            total_inventory: 1
            )
      }
      it "is valid when required fields are present" do
        expect(video.valid?).must_equal true
      end

      it "is invalid without a title" do
        video.title = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages).must_include :title
        expect(video.errors.messages[:title]).must_include "can't be blank"
      end

      it "is invalid without an overview" do
        video.overview = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages).must_include :overview
        expect(video.errors.messages[:overview]).must_include "can't be blank"
      end

      it "is invalid without a release date" do
        video.release_date = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:release_date]).must_include "can't be blank"
      end

      it "is invalid if release date is in the future" do
        video.release_date = DateTime.now + 1

        expect(video.valid?).must_equal false
      end

      it "is invalid if available inventory is nil" do
        video.available_inventory = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:available_inventory]).must_include "can't be blank"
      end

      it "is valid with 0 or more (non-negative) available inventory" do
        video.available_inventory = 0

        expect(video.valid?).must_equal true
      end

      it "is invalid with a negative available inventory" do
        video.available_inventory = -1

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:available_inventory]).must_include "must be greater than or equal to 0"
      end

      it "is invalid if total inventory is nil" do
        video.total_inventory = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:total_inventory]).must_include "can't be blank"
      end

      it "is valid with 0 or more (non-negative) total inventory" do
        video.total_inventory = 0

        expect(video.valid?).must_equal true
      end

      it "is invalid with a negative total inventory" do
        video.total_inventory = -1

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:total_inventory]).must_include "must be greater than or equal to 0"
      end
    end
  end
end
