require "test_helper"

describe Video do
  it "can be instantiated" do
    # really a sanity check

    videos.each do |video|
      expect(video.valid?).must_equal true
      expect(video.errors).must_be_empty
    end
  end

  it "will have the required fields" do
    Video.column_names.each do |field|
      expect(videos(:black_widow)).must_respond_to field
    end
  end

  describe "relations" do
    it "has a list of rentals" do
      expect(videos(:sing_street)).must_respond_to :rentals

      videos(:sing_street).rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has a list of renting customers" do
      expect(videos(:sing_street)).must_respond_to :customers

      videos(:sing_street).customers.each do |customer|
        expect(customer).must_be_kind_of Customer
      end
    end
  end

  describe "validations" do
    it "must contain the required fields" do
      empty_video = Video.create

      expect(empty_video.valid?).must_equal false

      [:title, :release_date, :available_inventory, :overview, :total_inventory].each do |field|
        expect(empty_video.errors[field]).must_include "can't be blank"
      end

    end
    it "must have a unique title" do
      videos(:black_widow).title = "Wonder Woman 2"

      expect(videos(:black_widow).valid?).must_equal false

      expect(videos(:black_widow).errors[:title]).must_include "has already been taken"
    end

    it "must have numerical, integer values for total/available inventory" do
      error_message_hash = {"NaN" => "is not a number", 1.5 => "must be an integer"}
      # ^ allows us to test for invalid number and integer input in one neat test :)
      [:total_inventory, :available_inventory].each do |field|
        error_message_hash.each do |error, message|
          videos(:black_widow)[field] = error

          expect(videos(:black_widow).valid?).must_equal false

          expect(videos(:black_widow).errors[field]).must_include message
        end
      end
    end

    it "must have a total_inventory greater than 0" do
      videos.each do |video|
        video.total_inventory = 0
        expect(video.valid?).must_equal false
        expect(video.errors[:total_inventory]).must_include "must be greater than 0"
      end
    end

    it "must have available inventory between 0 and total_inventory, inclusive" do
      [-1, videos(:black_widow).total_inventory + 1].each do |stock|
        videos(:black_widow).available_inventory = stock
        expect(videos(:black_widow).valid?).must_equal false
        message = stock < 0 ? "must be greater than or equal to 0" : "must be less than or equal to #{videos(:black_widow).total_inventory}"
        expect(videos(:black_widow).errors[:available_inventory]).must_include message
      end
    end

    it "must have a release date string carrying a valid date" do
      videos(:black_widow).release_date = "not a date"
      expect(videos(:black_widow).valid?).must_equal false

      expect(videos(:black_widow).errors[:release_date]).must_include "must be valid date"
    end
  end
end
