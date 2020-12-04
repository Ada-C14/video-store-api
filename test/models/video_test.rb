require "test_helper"

describe Video do
  describe "validations" do
    before do
      @video = {
          title: "Titanic",
          overview: "Greatest movie ever",
          release_date: "1994-11-21",
          total_inventory: 5,
          available_inventory: 5
      }
      end

      it "creates video with all the required validations" do
        video = Video.new(@video)

        expect(video.valid?).must_equal true
      end

      it "is invalid without a title" do
        @video["title"] = nil

        video = Video.new(@video)

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:title]).must_equal ["can't be blank"]
      end

      it "is invalid without an overview" do
        @video["overview"] = nil

        video = Video.new(@video)

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:overview]).must_equal ["can't be blank"]
      end

      it "is invalid without a release date" do
        @video["release_date"] = nil

        video = Video.new(@video)

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
      end

      it "is invalid without a total inventory" do
        @video["total_inventory"] = nil

        video = Video.new(@video)

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:total_inventory]).must_equal ["can't be blank"]
      end

      it "is invalid without an available inventory" do
        @video["available_inventory"] = nil

        video = Video.new(@video)

        expect(video.valid?).must_equal false
        expect(video.errors.messages[:available_inventory]).must_equal ["can't be blank"]
      end

    end
  end
