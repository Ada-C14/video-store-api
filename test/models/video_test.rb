require "test_helper"

describe Video do
  describe "relations" do

    it "has rentals" do
      video_one = videos(:wonder_woman)
      expect(video_one).must_respond_to :rentals
      video_one.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has customers through rentals" do
      video_one = videos(:wonder_woman)
      expect(video_one).must_respond_to :customers
      video_one.customer.each do |customer|
        expect(customer).must_be_kind_of Customer
      end
    end

  end

  describe "validations" do

    before do
      @video = Video.new(title: "Title", overview: "Overview", release_date: "January 1st 2021", total_inventory: 10, available_inventory: 9)
    end

    it "must have a title" do
      @video.title = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :title
    end

    it "must have an overview" do
      @video.overview = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :overview
    end

    it "must have a release_date" do
      @video.release_date = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :release_date
    end

    it "must have a total_inventory" do
      @video.total_inventory = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :total_inventory
    end

    it "must have an available_inventory" do
      @video.available_inventory = nil
      expect(@video.valid?).must_equal false
      expect(@video.errors.messages).must_include :available_inventory
    end

    it "must have a unique title" do
      @video.save!
      title = @video.title
      video_copy = Video.new(title: title)
      result = (video_copy.save)
      expect(result).must_equal false
      expect(video_copy.errors_messages).must_include :title
    end


  end

end
