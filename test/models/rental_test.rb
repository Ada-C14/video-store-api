require "test_helper"

describe Rental do

  describe "check_out" do
    it "returns true with valid customer and video" do
      #arrange
      customer = customers(:customer_two)
      video = videos(:wonder_woman)
      date = DateTime.now + 1.week
      customer.save
      video.save
      rental = Rental.create(customer: customer, video: video, due_date: date)

      # act
      inventory = video.available_inventory
      videos_checked_out_count = customer.videos_checked_out_count
      result = rental.check_out(customer, video)

      # assert
      expect(result).must_equal true
      expect(video.available_inventory).must_equal inventory - 1
      expect(customer.videos_checked_out_count).must_equal videos_checked_out_count + 1
    end

    it "returns false if available inventory is invalid" do
      #arrange
      customer = customers(:customer_two)
      video = videos(:wonder_woman)
      date = DateTime.now + 1.week
      video.available_inventory = 0
      video.save
      customer.save
      rental = Rental.create(customer_id: customer, video_id: video, due_date: date)

      checked_out_count = customer.videos_checked_out_count
      result = rental.check_out(customer, video)

      expect(result).must_equal false
      expect(customer.videos_checked_out_count).must_equal checked_out_count
    end
  end


  describe "check_in" do
    it "returns true with valid customer and video" do
      #arrange
      customer = customers(:customer_two)
      video = videos(:wonder_woman)
      date = DateTime.now + 1.week
      customer.save
      video.save
      rental = Rental.create(customer: customer, video: video, due_date: date)

      # act
      inventory = video.available_inventory
      videos_checked_out_count = customer.videos_checked_out_count
      result = rental.check_in(customer, video)

      # assert
      expect(result).must_equal true
      expect(video.available_inventory).must_equal inventory + 1
      expect(customer.videos_checked_out_count).must_equal videos_checked_out_count - 1
    end

    it "returns false if available inventory is invalid" do
      #arrange
      customer = customers(:customer_two)
      video = videos(:wonder_woman)
      date = DateTime.now + 1.week
      customer.videos_checked_out_count = 0

      video.save
      customer.save
      rental = Rental.create(customer_id: customer, video_id: video, due_date: date)

      videos_checked_out_count  = customer.videos_checked_out_count
      result = rental.check_in(customer, video)

      expect(result).must_equal false
      expect(customer.videos_checked_out_count).must_equal videos_checked_out_count
    end
  end

  describe "videos_checked_out_count" do
    it"returns the value of videos_checked_out_count" do
      #arrange
      customer = customers(:customer_two)

      #act+assert
      expect(customer.videos_checked_out_count).must_equal 1
    end
  end

  describe "available_inventory" do
    it"returns the value of available_inventory" do
      #arrange
      video = videos(:wonder_woman)

      #act+assert
      expect(video.available_inventory).must_equal 100
    end
  end
end
