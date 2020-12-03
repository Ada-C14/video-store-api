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
        check_invalid(model: video, attribute: :title)
      end

      it "is invalid without an overview" do
        video.overview = nil

        expect(video.valid?).must_equal false
        check_invalid(model: video, attribute: :overview)
      end

      it "is invalid without a release date" do
        video.release_date = nil
        check_invalid(model: video, attribute: :release_date)
      end

      it "is invalid if available inventory is nil" do
        video.available_inventory = nil
        check_invalid(model: video, attribute: :available_inventory)

      end

      it "is valid with 0 or more (non-negative) available inventory" do
        video.available_inventory = 0
        expect(video.valid?).must_equal true
      end

      it "is invalid with a negative available inventory" do
        video.available_inventory = -1
        check_invalid(model: video, attribute: :available_inventory)
      end

      it "is invalid if total inventory is nil" do
        video.total_inventory = nil
        check_invalid(model: video, attribute: :total_inventory)
      end

      it "is valid with 0 or more (non-negative) total inventory" do
        video.total_inventory = 0
        expect(video.valid?).must_equal true
      end

      it "is invalid with a negative total inventory" do
        video.total_inventory = -1
        check_invalid(model: video, attribute: :total_inventory)
      end
    end
  end
end
