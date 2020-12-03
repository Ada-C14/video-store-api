require "test_helper"

describe Video do

  let (:new_video) {
    Video.new(title: "test", overview: "its about tests", release_date: "2020-12-2", total_inventory: 5, available_inventory: 3)
  }

  it "can be instantiated" do
    expect(new_video.valid?).must_equal true
  end

  it "will have all the proper fields" do
    new_video.save
    video = Video.first
    [:title, :overview, :release_date, :total_inventory, :available_inventory].each do |field|
      expect(video).must_respond_to field
    end
  end

  describe "validations" do
    it "must have a title" do
      new_video[:title] = nil

      expect(new_video.valid?).must_equal false
      expect(new_video.errors.messages).must_include :title
      expect(new_video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "must have an overview" do
      new_video[:overview] = nil

      expect(new_video.valid?).must_equal false
      expect(new_video.errors.messages).must_include :overview
      expect(new_video.errors.messages[:overview]).must_equal ["can't be blank"]
    end

    it "must have a release date" do
      new_video[:release_date] = nil

      expect(new_video.valid?).must_equal false
      expect(new_video.errors.messages).must_include :release_date
      expect(new_video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end

    it "must have a total inventory attribute and it must be a number greater than 0" do
      new_video[:total_inventory] = nil

      expect(new_video.valid?).must_equal false
      expect(new_video.errors.messages).must_include :total_inventory
      expect(new_video.errors.messages[:total_inventory]).must_equal ["can't be blank", "is not a number"]
    end

    it "must have an available inventory attribute and it must be a number greater than 0" do
      new_video[:available_inventory] = nil

      expect(new_video.valid?).must_equal false
      expect(new_video.errors.messages).must_include :available_inventory
      expect(new_video.errors.messages[:available_inventory]).must_equal ["can't be blank", "is not a number"]
    end
  end

  describe "relationships" do
    it "can have many rentals" do
      customer = customers(:customer_two)
      customer2 = customers(:customer_one)
      video = videos(:black_widow)
      rental = Rental.create(due_date: Date.today + 7,
                          customer_id: customer.id,
                          video_id: video.id,
                          videos_checked_out_count: customer.videos_checked_out_count,
                          available_inventory: video.available_inventory)

      rental2 = Rental.create(due_date: Date.today + 7,
                          customer_id: customer2.id,
                          video_id: video.id,
                          videos_checked_out_count: customer2.videos_checked_out_count,
                          available_inventory: video.available_inventory)

      expect(video.rentals.count).must_equal 2
      video.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end

    end
  end
end
