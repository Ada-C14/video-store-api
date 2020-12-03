require "test_helper"

describe Video do

  it "can be instianted with the fields" do
    video = Video.first
    expect(video.valid?).must_equal true
  end

  it "responds to the fields" do
    video = Video.first
    [:title, :release_date, :available_inventory].each do |field|
      expect(video).must_respond_to field
    end
  end

  describe "validations" do

    it "video must have a title" do
      # Arrange
      video = Video.first
      video.title = nil
      # Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "video title must be unique" do
      #Arrange
      video_1 = Video.find_by(title: 'Wonder Woman 2')
      video_2 = Video.find_by(title: 'Black Widow')
      video_2.title = video_1.title
      video_2.save
      #Assert
      expect(video_2.valid?).must_equal false
      expect(video_2.errors.messages).must_include :title
      expect(video_2.errors.messages[:title]).must_equal ["has already been taken"]
    end

    it "video must have a release date" do
      #Arrange
      video = Video.first
      video.release_date = nil
      #Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :release_date
      expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end

    it "video must have an available inventory" do
      video = Video.last
      video.available_inventory = nil
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "can't be blank"
    end

    it "video's available inventory must be a number" do
      video = Video.last
      video.available_inventory = 'five'
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "is not a number"
    end

    it "video's available inventory must be greater or equal to 0" do
      video = Video.last
      video.available_inventory = -1
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_include "must be greater than or equal to 0"
    end
  end

  describe "relations" do
    before do
      @video_1 = videos(:inception)
      @video_2 = videos(:black_widow)
    end

    describe "rentals" do
      it "can have many rentals" do
        expect(@video_2).must_respond_to :rentals

        @video_2.rentals.each do |rental|
          expect(rental).must_be_instance_of Rental
        end

        expect(@video_2.rentals.count).must_equal 2
      end

      it "can have zero rental" do
        expect(@video_1.rentals.count).must_equal 0
      end
    end

    describe "customers" do
      it "can have many customers through rentals" do
        expect(@video_2).must_respond_to :customers

        @video_2.customers.each do |customer|
          expect(customer).must_be_instance_of Customer
        end

      end
      it "can have zero customers" do
        expect(@video_1.customers.count).must_equal 0
      end
    end
  end
end
