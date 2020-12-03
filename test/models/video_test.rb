require "test_helper"

describe Video do
  let (:video_one) { videos(:wonder_woman) }

  describe "relationships" do
    it "has many rentals" do
      rentals = video_one.rentals
      expect(rentals.length).must_equal 2
      rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end

  describe "validations" do
    let (:video_hash) do
      {
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: "December 16th 2025",
        total_inventory: 6,
        available_inventory: 6
      }
    end

    it "must have a title" do
      video_hash[:title] = nil
      video = Video.create(video_hash)
      found_video = Video.find_by(overview: video_hash[:overview])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :title
    end

    it "must have a overview" do
      video_hash[:overview] = nil
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :overview
    end

    it "must have a total_inventory" do
      video_hash[:total_inventory] = nil
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :total_inventory
    end

    it "must have a available_inventory" do
      video_hash[:available_inventory] = nil
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :available_inventory
    end
    it "must have a release_date" do
      video_hash[:release_date] = nil
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :release_date
    end
    it "total_inventory must be >= 0" do
      video_hash[:total_inventory] = -1
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :total_inventory
    end
    it "available_inventory must be >= 0" do
      video_hash[:available_inventory] = -1
      video = Video.create(video_hash)
      found_video = Video.find_by(title: video_hash[:title])
      expect(found_video).must_be_nil
      expect(video.valid?).must_equal false
      expect(video.errors.keys).must_include :available_inventory
    end
  end

  describe "custom methods" do
    describe "decrement_inventory" do
      it "decrements available_inventory for existing video" do
        before_available = video_one.available_inventory
        before_total = video_one.total_inventory
        video_one.decrement_inventory
        expect(video_one.available_inventory).must_equal before_available - 1
        expect(video_one.total_inventory).must_equal before_total
      end
      it "NoMethodError raised for call on nil video" do
        video = nil

        expect {
          video.decrement_inventory
        }.must_raise NoMethodError
      end
    end

    describe "increment_inventory" do
      it "decrements available_inventory for existing video" do
        before_available = video_one.available_inventory
        before_total = video_one.total_inventory
        video_one.increment_inventory
        expect(video_one.available_inventory).must_equal before_available + 1
        expect(video_one.total_inventory).must_equal before_total
      end
      it "NoMethodError raised for call on nil video" do
        video = nil

        expect {
          video.increment_inventory
        }.must_raise NoMethodError
      end
    end

    describe "currently checked out to" do
      it "returns a list of customers to whom the video is currently checked out" do
        customers = video_one.currently_checked_out_to
        expect(customers).must_be_instance_of Array
        expect(customers.length).must_equal 2
        customers.each do |customer|
          expect(customer).must_be_instance_of Customer
        end
      end
      it "returns an empty array if the video is not currently checked out to anyone" do
        Rental.delete_all
        customers = video_one.currently_checked_out_to
        expect(customers).must_be_instance_of Array
        expect(customers.length).must_equal 0
      end
    end

    describe "checkout history" do
      it "returns a list of customers to whom the video was previously checked out" do
        rental_one = rentals(:rental_one)
        rental_one.update!(due_date: Date.tomorrow, updated_at: Date.tomorrow)

        customers = video_one.previously_checked_out_to
        expect(customers).must_be_instance_of Array
        expect(customers.length).must_equal 1
        customers.each do |customer|
          expect(customer).must_be_instance_of Customer
        end
      end
      it "returns an empty array if the video is not currently checked out to anyone" do
        Rental.delete_all
        customers = video_one.previously_checked_out_to
        expect(customers).must_be_instance_of Array
        expect(customers.length).must_equal 0
      end
    end
  end
end
